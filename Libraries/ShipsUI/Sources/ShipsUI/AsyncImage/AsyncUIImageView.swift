//
//  AsyncUIImageView.swift
//  ShipsCore
//
//  Created by Konstantine Tsirgvava on 28/03/2026.
//

import UIKit

public final class AsyncUIImageView: UIImageView {
    
    private var loadTask: Task<Void, Never>?
    private var currentURL: String?
    
    public func load(from urlString: String?, placeholder: UIImage? = UIImage(systemName: "photo")) {
        loadTask?.cancel()
        
        image = placeholder?.withRenderingMode(.alwaysTemplate)
        tintColor = .gray
        
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            return
        }
        
        currentURL = urlString
        
        loadTask = Task { [weak self] in
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard let loadedImage = UIImage(data: data) else { return }
                
                await MainActor.run {
                    guard self?.currentURL == urlString else { return }
                    self?.image = loadedImage
                }
            } catch {
                // keep placeholder :)
            }
        }
    }
    
    public func cancel() {
        loadTask?.cancel()
        loadTask = nil
        currentURL = nil
        image = nil
    }
}
