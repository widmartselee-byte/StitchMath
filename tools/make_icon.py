#!/usr/bin/env python3
"""Stitch Math 图标：毛线球 + 两根交叉的棒针。

配色思路：深靛蓝底 → 米白毛线球 → 赭色棒针压在球前面。
这样缩到 60px 也还有三层明暗，不会糊成一团。

用法：python3 tools/make_icon.py
输出：StitchMath/Resources/Assets.xcassets/AppIcon.appiconset/AppIcon.png（1024，无 alpha）
"""
import pathlib

from PIL import Image, ImageChops, ImageDraw

OUT = pathlib.Path(__file__).resolve().parent.parent / "StitchMath/Resources/Assets.xcassets/AppIcon.appiconset"
OUT.mkdir(parents=True, exist_ok=True)

S = 4096              # 超采样后缩到 1024
W = S // 4

BG_TOP = (66, 76, 122)
BG_BOTTOM = (36, 42, 70)
BALL = (245, 238, 226)
BALL_SHADE = (226, 214, 194)
BALL_STRAND = (205, 185, 155)
NEEDLE = (176, 104, 58)
NEEDLE_DARK = (138, 76, 40)


def lerp(a, b, t):
    return tuple(int(round(a[i] + (b[i] - a[i]) * t)) for i in range(3))


def blank():
    return Image.new("RGBA", (S, S), (0, 0, 0, 0))


def background():
    img = Image.new("RGB", (S, S), BG_TOP)
    d = ImageDraw.Draw(img)
    for y in range(S):
        d.line([(0, y), (S, y)], fill=lerp(BG_TOP, BG_BOTTOM, y / (S - 1)))
    return img.convert("RGBA")


def ball_layer(cx, cy, r):
    mask = Image.new("L", (S, S), 0)
    ImageDraw.Draw(mask).ellipse([cx - r, cy - r, cx + r, cy + r], fill=255)

    body = blank()
    bd = ImageDraw.Draw(body)
    bd.ellipse([cx - r, cy - r, cx + r, cy + r], fill=BALL + (255,))

    # 右下压暗，给球一点体积
    shade = blank()
    ImageDraw.Draw(shade).ellipse([cx - r * 0.35, cy - r * 0.30, cx + r * 1.05, cy + r * 1.05],
                                  fill=BALL_SHADE + (150,))
    shade.putalpha(ImageChops.multiply(shade.getchannel("A"), mask))
    body = Image.alpha_composite(body, shade)

    # 股线：低对比，只当纹理用，不然像一团乱麻
    strands = blank()
    for angle, sx, sy, width, alpha in (
        (-24, 0.92, 0.40, 44, 120),
        (-24, 0.66, 0.28, 36, 110),
        (-24, 0.40, 0.16, 28, 95),
        (22, 0.86, 0.36, 40, 110),
        (22, 0.58, 0.24, 32, 95),
        (70, 0.52, 0.30, 26, 80),
    ):
        layer = blank()
        ImageDraw.Draw(layer).ellipse(
            [cx - r * sx, cy - r * sy, cx + r * sx, cy + r * sy],
            outline=BALL_STRAND + (alpha,), width=width)
        strands = Image.alpha_composite(strands, layer.rotate(angle, center=(cx, cy),
                                                             resample=Image.BICUBIC))
    strands.putalpha(ImageChops.multiply(strands.getchannel("A"), mask))
    body = Image.alpha_composite(body, strands)

    rim = blank()
    ImageDraw.Draw(rim).ellipse([cx - r, cy - r, cx + r, cy + r],
                                outline=lerp(BALL_SHADE, BG_BOTTOM, 0.35) + (120,),
                                width=int(S * 0.007))
    return Image.alpha_composite(body, rim)


def needle_layer(angle_deg, cx, cy, length, width):
    """一根棒针：长针身 + 短锥尖 + 尾端圆帽，压在球前面。"""
    layer = blank()
    ld = ImageDraw.Draw(layer)
    half = length / 2
    shaft_top = width * 0.55
    ld.polygon([(cx - shaft_top, cy - half * 0.80),
                (cx + shaft_top, cy - half * 0.80),
                (cx + width * 0.34, cy + half),
                (cx - width * 0.34, cy + half)],
               fill=NEEDLE + (255,))
    # 针尖（锥形，顶端收成小圆头，不像铅笔削尖）
    ld.polygon([(cx - shaft_top, cy - half * 0.80),
                (cx + shaft_top, cy - half * 0.80),
                (cx, cy - half)],
               fill=NEEDLE + (255,))
    ld.ellipse([cx - width * 0.20, cy - half - width * 0.20,
                cx + width * 0.20, cy - half + width * 0.20],
               fill=NEEDLE + (255,))
    # 尾帽
    knob = width * 0.52
    ld.ellipse([cx - knob, cy + half - knob, cx + knob, cy + half + knob],
               fill=NEEDLE_DARK + (255,))
    # 针身上一道高光，避免整根死色
    hl = blank()
    ImageDraw.Draw(hl).polygon([(cx - shaft_top * 0.55, cy - half * 0.75),
                                (cx - shaft_top * 0.05, cy - half * 0.75),
                                (cx - width * 0.02, cy + half * 0.95),
                                (cx - width * 0.30, cy + half * 0.95)],
                               fill=(214, 150, 104, 130))
    layer = Image.alpha_composite(layer, hl)
    return layer.rotate(angle_deg, center=(cx, cy), resample=Image.BICUBIC)


def main():
    img = background()

    cx, cy, r = S * 0.5, S * 0.52, S * 0.285
    img = Image.alpha_composite(img, ball_layer(cx, cy, r))

    # 两根针在球前面交叉
    img = Image.alpha_composite(img, needle_layer(-38, cx - S * 0.055, cy + S * 0.01, S * 1.02, S * 0.034))
    img = Image.alpha_composite(img, needle_layer(38, cx + S * 0.055, cy + S * 0.01, S * 1.02, S * 0.034))

    img = img.convert("RGB")
    edge = ImageDraw.Draw(img)
    edge.rounded_rectangle([0, 0, S - 1, S - 1], radius=int(S * 0.20),
                           outline=lerp(BG_BOTTOM, BG_TOP, 0.45), width=int(S * 0.012))

    img = img.resize((W, W), Image.LANCZOS).convert("RGB")
    img.save(OUT / "AppIcon.png", format="PNG")
    print("已生成", OUT / "AppIcon.png", img.size, img.mode)


if __name__ == "__main__":
    main()
