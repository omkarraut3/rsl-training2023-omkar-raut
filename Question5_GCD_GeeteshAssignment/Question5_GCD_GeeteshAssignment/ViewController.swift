//
//  ViewController.swift
//  Question5_GCD_GeeteshAssignment
//
//  Created by Geetesh Mandaogade on 27/09/23.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Constant

    let imageURLs = [
        URL(string: "https://filesamples.com/samples/image/jpg/sample_640%C3%97426.jpg"),
        URL(string: "https://sample-videos.com/img/Sample-jpg-image-500kb.jpg")
    ]

    // MARK: - Overriden function

    override func viewDidLoad() {
        super.viewDidLoad()
        downloadImages()
    }

    // MARK: - Private Helpers

    /**
     does the main task for downloading image by creating concurrent queue for tasks
     */
    private func downloadImages() {
        let concurrentQueue = DispatchQueue(label: "com.assignment.getImages", attributes: .concurrent)
        let dispatchGroup = DispatchGroup()
        var fileURLs = [URL]()

        for (index, url) in imageURLs.enumerated() {
            guard let url = url else {
                return
            }

            dispatchGroup.enter()
            concurrentQueue.async {
                if let data = try? Data(contentsOf: url) {
                    let fileName = "imageDownloaded\(index)"
                    if let fileURL = self.saveImageDataToDisk(data, with: fileName) {
                        fileURLs.append(fileURL)
                    }
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.displayImagesToUI(fileURLs: fileURLs)
        }
    }

    /**
     Saves image to the disk and returns the file location URL
     */
    private func saveImageDataToDisk(_ data: Data, with filename: String) -> URL? {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
        do {
            try data.write(to: fileURL)
            print("Saved image: \(filename)")
            print("fileURL: \(fileURL)")
            return fileURL
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }

    /**
     Displays downloaded images to the UI
     */
    private func displayImagesToUI(fileURLs: [URL]) {
        let label = UILabel()
        label.text = "Downloaded Images:"
        label.frame = CGRect(x: 20, y: 150, width: 300, height: 50)
        view.addSubview(label)

        for (index, url) in fileURLs.enumerated() {
            let imageView = UIImageView()
            imageView.frame = CGRect(x: 20 + index * 200, y: 200, width: 150, height: 150)
            if let image = UIImage(contentsOfFile: url.path) {
                imageView.image = image
                self.view.addSubview(imageView)
            }
        }
    }
}

