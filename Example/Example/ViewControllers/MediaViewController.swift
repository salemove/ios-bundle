import Foundation
import UIKit
import SalemoveSDK

private extension Selector {
    static let handleRemoteVideoTap = #selector(MediaViewController.handleRemoteVideoTap)
    static let handleLocalVideoTap = #selector(MediaViewController.handleLocalVideoTap)
}

class MediaViewController: UIViewController {
    @IBOutlet weak var remoteMediaStack: UIStackView!
    @IBOutlet weak var localMediaStack: UIStackView!

    var remoteVideoStream: VideoStreamable?
    var localVideoStream: VideoStreamable?

    override func viewDidLoad() {
        super.viewDidLoad()

        let remoteTapGesture = UITapGestureRecognizer(target: self, action: .handleRemoteVideoTap)
        remoteMediaStack.addGestureRecognizer(remoteTapGesture)

        let localTapGesture = UITapGestureRecognizer(target: self, action: .handleLocalVideoTap)
        localMediaStack.addGestureRecognizer(localTapGesture)
    }

    func handleVideoStream(stream: VideoStreamable) {
        if stream.isRemote {
            remoteVideoStream = stream
            let view = remoteVideoStream!.getStreamView()
            remoteMediaStack.insertArrangedSubview(view, at: 0)
            remoteVideoStream!.playVideo()
        } else {
            localVideoStream = stream
            let view = localVideoStream!.getStreamView()
            localMediaStack.insertArrangedSubview(view, at: 0)
            localVideoStream!.playVideo()
        }
    }

    func handleAudioStream(stream: AudioStreamable) {
        stream.playAudio()
    }

    func handleScreenStream(stream: VideoStreamable) {
        stream.playVideo()
    }

    @objc func handleRemoteVideoTap() {
        guard let remoteStream = remoteVideoStream else {
            return
        }

        remoteStream.isPaused ? remoteStream.resume() : remoteStream.pause()
    }

    @objc func handleLocalVideoTap() {
        guard let localStream = localVideoStream else {
            return
        }

        localStream.isPaused ? localStream.resume() : localStream.pause()
    }

    func cleanUp() {
        remoteVideoStream = nil
        localVideoStream = nil
    }

    deinit {
        cleanUp()
    }
}
