//
//  AsyncTaskJson.swift
//  TTExoMind
//
//  Created by Thibaud Lambert on 25/01/2021.
//

import Foundation

/// Classe permettant de récupérer des données au format JSON depuis un appel réseau
class AsyncTaskJson<Result: Codable> {
    var onPreExecute: (() -> Void)?
    var onPostExecute: ((Result?, Error?) -> Void)?

    fileprivate var result: Result?
    fileprivate var url: URL

    init(url: URL) {
        self.url = url
    }

    func execute() {
        self.onPreExecute?()

        URLSession.shared.dataTask(with: self.url) { (data, _, error) in
            guard let data = data,
                error == nil
                else { return }

            do {
                let jsonData = try JSONDecoder().decode(Result.self, from: data)
                self.result = jsonData

                DispatchQueue.main.async {
                    self.onPostExecute?(self.result, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    self.result = nil
                    self.onPostExecute?(self.result, error)
                }
            }
        }.resume()
    }
}
