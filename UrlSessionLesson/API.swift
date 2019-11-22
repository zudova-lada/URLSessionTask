//
//  API.swift
//  UrlSessionLesson
//
//  Created by Константин Богданов on 06/11/2019.
//  Copyright © 2019 Константин Богданов. All rights reserved.
//

import UIKit

//https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=dab4052df3cc23ed39745a8cca163e0a&text=cat&extras=url_s&format=json&nojsoncallback=1

class API {

	private static let apiKey = "eca90a3a9f0c959cb2b2ecdbce8deb7a"
	private static let baseUrl = "https://www.flickr.com/services/rest/"


	static func searchPath(text: String, extras: String) -> URL {
		guard var components = URLComponents(string: baseUrl) else {
			return URL(string: baseUrl)!
		}

		let methodItem = URLQueryItem(name: "method", value: "flickr.photos.search")
		let apiKeyItem = URLQueryItem(name: "api_key", value: apiKey)
		let textItem = URLQueryItem(name: "text", value: text)
		let extrasItem = URLQueryItem(name: "extras", value: extras)
		let formatItem = URLQueryItem(name: "format", value: "json")
		let nojsoncallbackItem = URLQueryItem(name: "nojsoncallback", value: "1")

		components.queryItems = [methodItem, apiKeyItem, textItem, extrasItem, formatItem, nojsoncallbackItem]

		return components.url!
	}
}
