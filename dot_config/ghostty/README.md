<img width="473" height="57" alt="Ghostty text shaders" src="https://github.com/user-attachments/assets/04075bb2-2eef-4717-b114-d03c4d84cf61" />

Give your [Ghostty](https://github.com/ghostty-org/ghostty) terminal a Web 2.0
style makeover using shaders!

This repo contains 2 shaders:
 - [text-gradient.glsl](./text-gradient.glsl) gives text a gradient, shadow, and shine
 - [scanlines.glsl](./scanlines.glsl) adds a stripe pattern to the background


## Screenshots

<details open>
    <summary>One Half Dark / Berkeley Mono</summary>
    <img width="898" height="654" alt="One Half Dark screenshot" src="https://github.com/user-attachments/assets/2a2b2c43-816c-4a84-b412-8d09a32aa63b" />
</details>

<details>
    <summary>Monokai Classic / Cascadia Code</summary>
    <img width="833" height="646" alt="Screenshot 2026-05-19 at 3 32 29 PM" src="https://github.com/user-attachments/assets/2ab2420f-da80-407c-9d44-1a81a7281524" />
</details>

<details>
    <summary>Kanagawa Wave / Triplicate T4</summary>
    <img width="841" height="641" alt="Kanagawa Wave screenshot" src="https://github.com/user-attachments/assets/928defa6-2f2c-4f1e-a56c-d35cb256d898" />
</details>


## Caveats

It turns out that slapping a gradient on top of every terminal row can cause
some ugliness.

- [x] **Dark-on-Light.** Dark text on a light background generally does not look
  good with a gradient. This is handled by detecting and excluding these
  characters from treatment.

  | Before | After |
  | --- | --- |
  | <img width="410" height="110" alt="Dark-on-light issue" src="https://github.com/user-attachments/assets/90e84dd7-cb32-4c58-9454-9bf014bdfbdc" /> | <img width="410" height="110" alt="Dark-on-light issue handled" src="https://github.com/user-attachments/assets/8cd431a2-737f-4a6a-a7cf-93e078345d18" /> |

- [x] **Vertical borders**. Vertical border glyphs that span the full row height
  do not look good with a gradient. This is handled by detecting and excluding
  these characters from treatment.

  | Before | After |
  | --- | --- |
  | <img width="336" height="86" alt="Vertical border issue" src="https://github.com/user-attachments/assets/f324da12-8c85-4262-b3fe-47c9e6d037f2" /> | <img width="335" height="90" alt="Vertical border issue handled" src="https://github.com/user-attachments/assets/5d9ae87d-67a8-4193-81e5-82e5cafd6dd0" /> |

- [x] **Overflowing underlines.** In certain fonts, double/squiggly underlines
  can overflow into the next row, revealing the gradient discontinuity at row
  borders. This is handled by reducing the gradient’s brightness for the top
  few pixels of every row (configured by [`GRADIENT_SEAM_SOFTEN_PX`](./text-gradient.glsl#L19)).
  Alternatively you could handle this using something like
  `adjust-underline-position = -3` in your `config`.

  | Before | After |
  | --- | --- |
  | <img width="69" height="72" alt="Overflowing underline issue" src="https://github.com/user-attachments/assets/72339e25-256d-4280-8cbf-7523b9828598" /> | <img width="69" height="72" alt="Overflowing underline issue handled" src="https://github.com/user-attachments/assets/e631a701-78c6-4463-9b6d-ded31f247e2f" /> |

- [ ] **Emoji.** Colorful emoji generally don't look good with a gradient
  modifying their brightness. This is not currently handled.

  | Before | After |
  | --- | --- |
  | <img width="89" height="60" alt="Emoji issue" src="https://github.com/user-attachments/assets/524ff60d-6e66-4d63-9044-f233019413df" /> | n/a |

- [ ] **Images.** Images rendered using Kitty graphics protocol
  contain many artifacts. This is not currently handled.

  | Before | After |
  | --- | --- |
  | <img width="121" height="120" alt="Images issue" src="https://github.com/user-attachments/assets/a027faa1-c73b-4785-8138-532e2bf7dc2a" /> | n/a |


## Installation

Clone and copy the shaders into your Ghostty config directory (usually
`~/.config/ghostty`):

```sh
git clone https://github.com/beardedsakimonkey/ghostty-text-shaders.git
cp -i ghostty-text-shaders/*.glsl ~/.config/ghostty/
```

Then paste this into your Ghostty `config` and reload:

```ini
custom-shader = text-gradient.glsl
custom-shader = scanlines.glsl

# optionally for performance
custom-shader-animation = false
```


## Configuration

After installing, run `ghostty +list-themes` to check for rendering issues.

Configuration is done by modifying the variables at the top of each `.glsl`
file.

> [!WARNING]
> If you notice a gradient discontinuity repeated in every row, you should
> adjust [`GRADIENT_Y_OFFSET_PX`](./text-gradient.glsl#L12) to align the
> gradient with terminal rows.


## More Ghostty Shaders

- <https://github.com/sahaj-b/ghostty-cursor-shaders>
- <https://github.com/0xhckr/ghostty-shaders>
