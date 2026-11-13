# Looser line boxes — a Tern plugin

Tern writes tight line boxes (`font: 14px/1 …`) on several small surfaces, so
descenders — the tails of `g`, `y`, `p`, `q` — are cut flat at the box edge.
This plugin raises `line-height` to `1.5` exactly where that happens, and
changes nothing else.

Surfaces covered:

| Surface | What the stylesheet touches |
| --- | --- |
| Bottom status line | `#statusline`, `#statusline .tn-git` |
| Composer caption and status segments | `.sf-caption-name`, `.sf-caption-draft`, `.sf-status .sf-seg-t/.sf-text/.sf-t-accent` |
| Function-call card rows | `.sf-tool .sf-text`, `.sf-tool-title`, `.sf-tool-target`, `.sf-tool-meta`, `.sf-chip`, `.sf-t-code` … |
| Slash-command list | `.sf-overlay[data-role='omp.autocomplete'] .sf-item-label` |
| Terminal block bar (command lens) | `.sf-block-lens` |
| Terminal block bar (Native/Raw pair) | `.sf-block-seg .sf-block-opt` — the label's line box is pinned to the button height and the selected ring is inset, so the capsule no longer changes size when the choice moves |
| Left sidebar host-name row (tab chat style) | `.tn-vt .nm` |

Row heights and button rectangles do not move: the raised box stays inside the
existing padding. The reasoning and the live measurements behind each number
are in `window.luau`.

## Install

Tern manages plugins from its own directory. Install straight from this repo:

```sh
tern plugin install https://github.com/kingxuchen/tern-line-boxes
```

`github.com/kingxuchen/tern-line-boxes` also works as a shorthand, and the
`+ Install` action in Tern's plugin list accepts the same URL.

Upgrade an installed copy after new pushes:

```sh
tern plugin install https://github.com/kingxuchen/tern-line-boxes --force
```

Check that it loaded:

```sh
tern plugin list
```

Remove it:

```sh
tern plugin remove line-boxes
```

## Develop

```sh
git clone https://github.com/kingxuchen/tern-line-boxes
cd tern-line-boxes
tern plugin link .        # use this working copy in place
```

Edits to `window.luau` take effect on reload:

```sh
tern plugin reload line-boxes
```

`tern plugin link` keeps the plugin out of the install directory, so a later
`git pull` is all you need.

## Layout

```
plugin.toml   package manifest: id, name, version, description, entry file
window.luau   the plugin: tern.css blocks, one per surface
```

## License

MIT — see `LICENSE`.
