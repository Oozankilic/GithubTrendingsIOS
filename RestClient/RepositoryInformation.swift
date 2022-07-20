//
//  RepositoryInformation.swift
//  RestClient
//
//  Created by ozan kilic on 18.07.2022.
//

import Foundation

struct Initial:Codable
{
    var items: [RepositoryInformation]
}

struct RepositoryInformation:Codable
{
    let full_name: String
    let owner: Owner
    let description: String!
    let stargazers_count: Int
    let size: Int
    let forks_count: Int
    let open_issues_count: Int!
    let created_at: String
    let updated_at: String
}

struct Owner:Codable
{
    let avatar_url: String!
}
