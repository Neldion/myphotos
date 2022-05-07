//
//  Copyright (c) 2022 MyPhotos. All rights reserved.
//

import Foundation

enum DetailServiceError: Error {
  case parsingError
  case endPointError
  case detailError
}

protocol DetailService {
  func fetch(using url: String) async -> Result<Statistics, Error>
  func fetchUserDetail(using username: String) async -> Result<Contents, Error>
}

final class DefaultDetailService: DetailService {

  private let client: NetworkClient

  init(client: NetworkClient) {
    self.client = client
  }

  func fetch(using url: String) async -> Result<Statistics, Error> {
    do {
      guard let url = URL(string: "\(url)/statistics") else { return .failure(DetailServiceError.endPointError) }
      let (data, response) = try await client.request(url: url, method: .get)
      let decoder = DefaultServiceDecoder()
      let mpStats = try decoder.decode(type: MPStatistics.self, from: data)
      let stats = convert(mpStats)

      if let code = (response as? HTTPURLResponse)?.statusCode, code > 400 {
        return .failure(DetailServiceError.detailError)
      }

      return .success(stats)
    } catch let error {
      guard error is DecodingError else {
        return .failure(error)
      }
      return .failure(HomeServiceError.parsingError)
    }
  }

  func fetchUserDetail(using username: String) async -> Result<Contents, Error> {
    do {
      guard let url = URL(string: "\(DetailRoutes.userDetail.rawValue)\(username)/photos")
      else { return .failure(DetailServiceError.endPointError) }

      let (data, response) = try await client.request(url: url, method: .get)
      let decoder = DefaultServiceDecoder()
      let mpDetail = try decoder.decode(type: [MPContent].self, from: data)
      let detail = convert(mpDetail)

      if let code = (response as? HTTPURLResponse)?.statusCode, code > 400 {
        return .failure(DetailServiceError.detailError)
      }

      return .success(detail)
    } catch let error {
      guard error is DecodingError else {
        return .failure(error)
      }
      return .failure(HomeServiceError.parsingError)
    }
  }
}

enum DetailRoutes: String {
  case userDetail = "https://api.unsplash.com/users/"
}

extension DefaultDetailService {

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

  private func convert(_ mpStats: MPStatistics) -> Statistics {
    return Statistics(identifier: mpStats.id,
                      downloads: mpStats.downloads?.total ?? 0,
                      views: mpStats.views?.total ?? 0)
  }

  private func convert(_ mpUser: MPUser) -> User {
    return User(identifier: mpUser.id,
                avatar: mpUser.profileImage?.medium,
                name: mpUser.username ?? "",
                socialUsername: mpUser.social?.instagramUsername ?? mpUser.social?.twitterUsername ?? "")
  }
}
