import UIKit
import AVFoundation

// Example view controller that accesses camera
class ViewController: UIViewController {

   @IBOutlet weak var cameraPreview: UIView!
   var session: AVCaptureSession?
   var input: AVCaptureDeviceInput?
   var output: AVCaptureStillImageOutput?
   var previewLayer: AVCaptureVideoPreviewLayer?
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      //Initialize session an output variables this is necessary
      session = AVCaptureSession()
      output = AVCaptureStillImageOutput()
      let camera = getDevice(.Back)
      
      do {
         input = try AVCaptureDeviceInput(device: camera)
      } catch let error as NSError {
         print(error)
         input = nil
      }
      
      if (session?.canAddInput(input)) {
         session?.addInput(input)
         output?.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]

         if (session?.canAddOutput(output)) {
            session?.addOutput(output)
            previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            previewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.Portrait
            previewLayer?.frame = cameraPreview.bounds
            cameraPreview.layer.addSublayer(previewLayer!)
            session?.startRunning()
         }
      }
   }
   
   //Get the camera (Front or Back)
   func getDevice(position: AVCaptureDevicePosition) -> AVCaptureDevice? {
      let devices: NSArray = AVCaptureDevice.devices();
      for device in devices {
         let deviceConverted = device as! AVCaptureDevice
         if(deviceConverted.position == position){
            return deviceConverted
         }
      }
      return nil
   }
}
