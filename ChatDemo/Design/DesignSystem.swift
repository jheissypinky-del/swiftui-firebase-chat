//
//  DesignSystem.swift
//  ChatDemo
//
//  Aura Chat design system, translated from the Figma DESIGN.md
//  Palette: sapphire blue primary, frosted cool-gray surfaces, ink contrasts.
//

import SwiftUI

// MARK: - Colors

extension Color {
    // Surfaces
    static let auraSurface = Color(hex: 0xFAF8FF)        // base canvas
    static let auraBackground = Color(hex: 0xFAF8FF)
    static let auraSurfaceContainerLowest = Color(hex: 0xFFFFFF)
    static let auraSurfaceContainerLow = Color(hex: 0xF2F3FF)
    static let auraSurfaceContainer = Color(hex: 0xEAEDFF)
    static let auraSurfaceContainerHigh = Color(hex: 0xE2E7FF)
    static let auraSurfaceContainerHighest = Color(hex: 0xDAE2FD)

    // On-surface
    static let auraOnSurface = Color(hex: 0x131B2E)       // primary typography
    static let auraOnSurfaceVariant = Color(hex: 0x424656)
    static let auraInverseSurface = Color(hex: 0x283044)

    // Outline
    static let auraOutline = Color(hex: 0x727687)
    static let auraOutlineVariant = Color(hex: 0xC2C6D8)

    // Primary (sapphire)
    static let auraPrimary = Color(hex: 0x0066FF)
    static let auraOnPrimary = Color.white
    static let auraPrimaryContainer = Color(hex: 0x0066FF)

    // Secondary
    static let auraSecondary = Color(hex: 0x005AB3)

    // Tertiary (vitality green / availability)
    static let auraTertiary = Color(hex: 0x30D158)

    // Error
    static let auraError = Color(hex: 0xBA1A1A)

    // Semantic helpers
    static let auraIncomingBubble = Color(hex: 0xEEF2F8)
    static let auraGlassBar = Color.white.opacity(0.78)
    static let auraOnTertiaryContainer = Color.white
}

private extension Color {
    init(hex: UInt32, opacity: Double = 1.0) {
        let red = Double((hex >> 16) & 0xFF) / 255.0
        let green = Double((hex >> 8) & 0xFF) / 255.0
        let blue = Double(hex & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, opacity: opacity)
    }
}

// MARK: - Typography

extension Font {
    // Headlines (Plus Jakarta Sans; falls back to system with matching weight)
    static let auraHeadlineXL = Font.system(size: 34, weight: .bold, design: .default)
    static let auraHeadlineLG = Font.system(size: 24, weight: .semibold, design: .default)
    static let auraHeadlineMD = Font.system(size: 20, weight: .semibold, design: .default)
    static let auraHeadlineSM = Font.system(size: 17, weight: .semibold, design: .default)

    // Body
    static let auraBodyLG = Font.system(size: 17, weight: .regular, design: .default)
    static let auraBodyMD = Font.system(size: 15, weight: .regular, design: .default)
    static let auraBodySM = Font.system(size: 13, weight: .regular, design: .default)

    // Labels (metadata, timestamps, badges)
    static let auraLabelLG = Font.system(size: 14, weight: .semibold, design: .default)
    static let auraLabelMD = Font.system(size: 12, weight: .medium, design: .default)
    static let auraLabelSM = Font.system(size: 11, weight: .medium, design: .default)
}

// MARK: - Shapes

extension CGFloat {
    static let auraRadiusPill: CGFloat = 20
    static let auraRadiusCard: CGFloat = 24
    static let auraRadiusBubble: CGFloat = 18
    static let auraRadiusSmall: CGFloat = 8
}

// MARK: - Spacing

extension CGFloat {
    static let auraGutter: CGFloat = 16
    static let auraSpaceXS: CGFloat = 4
    static let auraSpaceSM: CGFloat = 8
    static let auraSpaceMD: CGFloat = 12
    static let auraSpaceLG: CGFloat = 16
    static let auraSpaceXL: CGFloat = 24
}

// MARK: - View modifiers

extension View {
    func auraCard() -> some View {
        self
            .background(Color.auraSurfaceContainerLowest)
            .clipShape(RoundedRectangle(cornerRadius: .auraRadiusCard, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: .auraRadiusCard, style: .continuous)
                    .stroke(Color.black.opacity(0.04), lineWidth: 0.5)
            )
            .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 2)
    }

    func auraGlassBar() -> some View {
        self
            .background(Color.auraGlassBar)
            .overlay(
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundStyle(Color.black.opacity(0.08)),
                alignment: .bottom
            )
    }
}
