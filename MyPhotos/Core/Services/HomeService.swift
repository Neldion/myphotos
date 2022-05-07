//
//  Copyright (c) 2022 MyPhotos. All rights reserved.
//

import Foundation

enum HomeServiceError: Error {
  case parsingError
  case endPointError
  case likeError
  case homeError
}

protocol HomeService {
  func fetch() async -> Result<Contents, Error>
  func like(id: String, shouldLike: Bool) async -> Result<Void, Error>
}

final class DefaultHomeService: HomeService {

  private let client: NetworkClient

  init(client: NetworkClient) {
    self.client = client
  }

  func fetch() async -> Result<Contents, Error> {
    do {
      guard let url = URL(string: HomeRoutes.home.rawValue)
      else { return .failure(HomeServiceError.endPointError )}
      let (data, response) = try await client.request(url: url, method: .get)
      let decoder = DefaultServiceDecoder()
      let mpHome = try decoder.decode(type: [MPContent].self, from: data)
      let home = convert(mpHome)

      if let code = (response as? HTTPURLResponse)?.statusCode, code > 400 {
        return .failure(HomeServiceError.homeError)
      }

      return .success(home)
    } catch let error {
      guard error is DecodingError else {
        return .failure(error)
      }
      return .failure(HomeServiceError.parsingError)
    }
  }

  func like(id: String, shouldLike: Bool) async -> Result<Void, Error> {
    do {
      guard let url = URL(string: "\(HomeRoutes.like.rawValue)\(id)/like")
      else { return .failure(HomeServiceError.endPointError )}
      let (_, response) = try await client.request(url: url, method: shouldLike ? .post : .delete)

      if let code = (response as? HTTPURLResponse)?.statusCode, code > 400 {
        return .failure(HomeServiceError.likeError)
      }

      return .success(())
    } catch let error {
      guard error is DecodingError else {
        return .failure(error)
      }
      return .failure(HomeServiceError.parsingError)
    }
  }

  enum HomeRoutes: String {
    case home = "https://api.unsplash.com/photos?per_page=20"
    case like = "https://api.unsplash.com/photos/"
  }
}

extension DefaultHomeService {

  private func convert(_ mpContents: [MPContent]) -> Contents {
    let posts = mpContents.compactMap {
      return Post(identifier: $0.id,
                  smallPicture: $0.urls?.small,
                  bigPicture: $0.urls?.full,
                  description: $0.description ?? "",
                  likes: $0.likes ?? 0,
                  isLiked: $0.likedByUser ?? false,
                  publicationDate: $0.updatedAt ?? $0.createdAt,
                  user: convert($0.user),
                  detailUrl: $0.links?.link)
    }
    return Contents(posts: posts)
  }

  private func convert(_ mpUser: MPUser) -> User {
    return User(identifier: mpUser.id,
                avatar: mpUser.profileImage?.medium,
                name: mpUser.username ?? "",
                socialUsername: mpUser.social?.instagramUsername ?? mpUser.social?.twitterUsername ?? "")
  }
}
