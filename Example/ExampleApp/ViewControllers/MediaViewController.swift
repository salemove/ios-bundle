import Foundation
import UIKit
import SalemoveSDK

private extension Selector {
    static let handleRemoteTap = #selector(MediaViewController.handleRemoteTap)
    static let handleLocalTap = #selector(MediaViewController.handleLocalTap)
}

class MediaViewController: UIViewController {
    @IBOutlet weak var remoteMediaStack: UIStackView!
    @IBOutlet weak var localMediaStack: UIStackView!

    var remoteVideoStream: VideoStreamable?
    var localVideoStream: VideoStreamable?

    weak var localVideoView: StreamView?
    weak var remoteVideoView: StreamView?

    var localAudioStream: AudioStreamable?
    var remoteAudioStream: AudioStreamable?

    override func viewDidLoad() {
        super.viewDidLoad()

        let remoteTapGesture = UITapGestureRecognizer(target: self, action: .handleRemoteTap)
        remoteMediaStack.addGestureRecognizer(remoteTapGesture)

        let localTapGesture = UITapGestureRecognizer(target: self, action: .handleLocalTap)
        localMediaStack.addGestureRecognizer(localTapGesture)
    }

    func handleVideoStream(stream: VideoStreamable) {
        if stream.isRemote {
            remoteVideoStream = stream
            let view = stream.getStreamView()
            remoteMediaStack.insertArrangedSubview(view, at: 0)
            stream.playVideo()

            remoteVideoView = view
        } else {
            localVideoStream = stream
            let view = stream.getStreamView()
            localMediaStack.insertArrangedSubview(view, at: 0)
            stream.playVideo()

            localVideoView = view
        }
    }

    func handleAudioStream(stream: AudioStreamable) {
        if stream.isRemote {
            remoteAudioStream = stream
        } else {
            localAudioStream = stream
        }
    }

    func chooseVideoScaling(streamView: StreamView?) {
        guard let videoView = streamView else {
            return
        }

        let controller = UIAlertController(title: "Scaling options", message: "Please choose action", preferredStyle: .actionSheet)

        let fillAction = UIAlertAction(title: "Scale to screen", style: .default) {_ in
            videoView.scale = .fill
        }

        let aspectFitAction = UIAlertAction(title: "Aspect fit", style: .default) { _ in
            videoView.scale = .aspectFit
        }

        let aspectFillAction = UIAlertAction(title: "Aspect fill", style: .default) { _ in
            videoView.scale = .aspectFill
        }

        controller.addAction(fillAction)
        controller.addAction(aspectFitAction)
        controller.addAction(aspectFillAction)

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        controller.addAction(cancel)

        present(controller, animated: true, completion: nil)
    }

    @objc func handleRemoteTap() {
        let controller = UIAlertController(title: "Remote stream", message: "Please choose action", preferredStyle: .actionSheet)

        if let videoStream = remoteVideoStream {
            let videoText = videoStream.isPaused ? "Resume video" : "Pause video"
            let videoAction = UIAlertAction(title: videoText, style: .default) { [unowned videoStream] _ in
                videoStream.isPaused ? videoStream.resume() : videoStream.pause()
            }

            let contentAction = UIAlertAction(title: "Change scaling", style: .default) { _ in
                self.chooseVideoScaling(streamView: self.remoteVideoView)
            }

            controller.addAction(videoAction)
            controller.addAction(contentAction)
        }

        if let audioStream = remoteAudioStream {
            let audioText = audioStream.isMuted ? "Unmute audio" : "Mute audio"
            let audioAction = UIAlertAction(title: audioText, style: .default) { [unowned audioStream] _ in
                audioStream.isMuted ? audioStream.unmute() : audioStream.mute()
            }

            controller.addAction(audioAction)
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        controller.addAction(cancel)

        present(controller, animated: true, completion: nil)
    }

    @objc func handleLocalTap() {
        let controller = UIAlertController(title: "Local stream", message: "Please choose action", preferredStyle: .actionSheet)

        if let videoStream = localVideoStream {
            let videoText = videoStream.isPaused ? "Resume video" : "Pause video"
            let videoAction = UIAlertAction(title: videoText, style: .default) { [unowned videoStream] _ in
                videoStream.isPaused ? videoStream.resume() : videoStream.pause()
            }

            let contentAction = UIAlertAction(title: "Change scaling", style: .default) { _ in
                self.chooseVideoScaling(streamView: self.localVideoView)
            }

            controller.addAction(videoAction)
            controller.addAction(contentAction)
        }

        if let audioStream = localAudioStream {
            let audioText = audioStream.isMuted ? "Unmute audio" : "Mute audio"
            let audioAction = UIAlertAction(title: audioText, style: .default) { [unowned audioStream] _ in
                audioStream.isMuted ? audioStream.unmute() : audioStream.mute()
            }

            controller.addAction(audioAction)
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        controller.addAction(cancel)

        present(controller, animated: true, completion: nil)
    }

    /// Toggles Audio On or Off on currently estabilished audio stream
    func toggleAudio() {
        guard let audioStream = localAudioStream else {
            debugPrint("No audio stream, can not toggle audio")
            return
        }
        audioStream.isMuted ? audioStream.unmute() : audioStream.mute()
    }

    /// Toggles Video On or Off on currently estabilished video stream
    func toggleVideo() {
        guard let videoStream = localVideoStream else {
            debugPrint("No video stream, can not toggle video")
            return
        }
        videoStream.isPaused ? videoStream.resume() : videoStream.pause()
    }

    func cleanUp() {
        remoteVideoStream = nil
        localVideoStream = nil
    }

    deinit {
        cleanUp()
    }
}
