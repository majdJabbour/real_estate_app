import AppKit
import ImageIO
import UniformTypeIdentifiers

enum RenderError: Error {
    case invalidSVG
    case cannotWrite(URL)
}

let platform = CommandLine.arguments[1]
let source = URL(fileURLWithPath: CommandLine.arguments[2])
let output = URL(fileURLWithPath: CommandLine.arguments[3], isDirectory: true)
guard let logo = NSImage(contentsOf: source), logo.size.width > 0, logo.size.height > 0 else {
    throw RenderError.invalidSVG
}

func render(_ destination: URL, pixels: Int, fraction: CGFloat, opaque: Bool) throws {
    let bitmapInfo = opaque ? CGImageAlphaInfo.noneSkipLast : CGImageAlphaInfo.premultipliedLast
    guard let canvas = CGContext(
        data: nil, width: pixels, height: pixels, bitsPerComponent: 8, bytesPerRow: 0,
        space: CGColorSpace(name: CGColorSpace.sRGB)!, bitmapInfo: bitmapInfo.rawValue
    ) else {
        throw RenderError.cannotWrite(destination)
    }

    let side = CGFloat(pixels)
    let bounds = CGRect(x: 0, y: 0, width: side, height: side)
    if opaque {
        canvas.setFillColor(CGColor(gray: 1, alpha: 1))
        canvas.fill(bounds)
    } else {
        canvas.clear(bounds)
    }

    let width = side * fraction
    let height = width * logo.size.height / logo.size.width
    let mark = CGRect(x: (side - width) / 2, y: (side - height) / 2, width: width, height: height)
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(cgContext: canvas, flipped: false)
    logo.draw(in: mark, from: .zero, operation: .sourceOver, fraction: 1)
    NSGraphicsContext.restoreGraphicsState()

    guard let image = canvas.makeImage(),
          let output = CGImageDestinationCreateWithURL(
            destination as CFURL, UTType.png.identifier as CFString, 1, nil
          ) else {
        throw RenderError.cannotWrite(destination)
    }
    CGImageDestinationAddImage(output, image, nil)
    guard CGImageDestinationFinalize(output) else {
        throw RenderError.cannotWrite(destination)
    }
}

func renderAndroid() throws {
    let densities: [(String, CGFloat)] = [
        ("mdpi", 1), ("hdpi", 1.5), ("xhdpi", 2), ("xxhdpi", 3), ("xxxhdpi", 4),
    ]
    for (density, scale) in densities {
        let folder = output.appendingPathComponent("mipmap-\(density)")
        try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        try render(folder.appendingPathComponent("ic_launcher.png"),
                   pixels: Int(48 * scale), fraction: 0.74, opaque: false)
        try render(folder.appendingPathComponent("ic_launcher_foreground.png"),
                   pixels: Int(108 * scale), fraction: 0.47, opaque: false)
        try render(folder.appendingPathComponent("launch_mark.png"),
                   pixels: Int(144 * scale), fraction: 134 / 144, opaque: false)
        try render(folder.appendingPathComponent("splash_mark.png"),
                   pixels: Int(288 * scale), fraction: 134 / 288, opaque: false)
    }
}

struct IconCatalog: Decodable {
    struct Entry: Decodable {
        let filename: String
        let size: String
        let scale: String
    }
    let images: [Entry]
}

func renderIOS() throws {
    let icons = output.appendingPathComponent("AppIcon.appiconset")
    let catalog = try JSONDecoder().decode(
        IconCatalog.self, from: Data(contentsOf: icons.appendingPathComponent("Contents.json"))
    )
    for entry in catalog.images {
        let points = Double(entry.size.split(separator: "x")[0])!
        let scale = Double(entry.scale.dropLast())!
        try render(icons.appendingPathComponent(entry.filename),
                   pixels: Int(points * scale), fraction: 0.74, opaque: true)
    }

    let launch = output.appendingPathComponent("LaunchImage.imageset")
    for (suffix, scale) in [("", 1), ("@2x", 2), ("@3x", 3)] {
        try render(launch.appendingPathComponent("LaunchImage\(suffix).png"),
                   pixels: 144 * scale, fraction: 134 / 144, opaque: false)
    }
}

if platform == "android" {
    try renderAndroid()
} else {
    try renderIOS()
}
