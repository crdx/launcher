# launcher

**launcher** is a wrapper around `dmenu`. It's similar to `dmenu_run` but instead of binaries it selects from applications registered via `*.desktop` files from XDG-compatible locations. It is written in Crystal.

## Build

```bash
crystal build main.cr --no-debug --release -o launcher
```

## Dependencies

- [dmenu](https://tools.suckless.org/dmenu/) with (optional) [line-height patch](https://tools.suckless.org/dmenu/patches/line-height/).
    - Remove the `-h` flag from the call to dmenu if height customisation is not needed.

## Usage

Assign window manager shortcut to run the launcher.

Desktop files are searched for in the following locations and order of precedence:

- `$HOME/.local/share`
- Paths listed in `XDG_DATA_DIRS`.

If a desktop file exists in multiple locations with the same name then the display name will also contain the basename of the desktop file.

### Sort order

Each time an application is launched its count is incremented in `$HOME/.config/launcher/stats.ini`.

The most commonly run applications are placed first in the list of choices.

### Logs

Each time an application is launched an entry is logged to `$HOME/.config/launcher/log.txt`.

## Contributions

Open an [issue](https://github.com/crdx/launcher/issues) or send a [pull request](https://github.com/crdx/launcher/pulls).

## Licence

[GPLv3](LICENCE).
