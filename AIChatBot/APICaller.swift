//
//  APICaller.swift
//  AIChatBot
//
//  Created by naoyuki.kan on 2022/12/16.
//

import Foundation
import OpenAISwift

final class APICaller {
    static let shared = APICaller()
    
    private init() {}
    
    private var client: OpenAISwift?
    
    @frozen enum Constants  {
        static let key = "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"
    }
    
    public func setup() {
        self.client = OpenAISwift(authToken: Constants.key)
    }
    
    public func getRespose(input: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        client?.sendCompletion(with: input, completionHandler: { result in
            switch result {
            case .success(let model):
                let output = model.choices.first?.text ?? ""
                completion(.success(output))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
