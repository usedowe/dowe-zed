# Dowe Zed

Dowe Zed is the dedicated Zed extension repository for Dowe Source Format files.

This repository contains the Zed extension adapter, language metadata, Tree-sitter queries, and the Dowe Tree-sitter grammar used by Zed. It recognizes `.dowe` files as `Dowe` and starts `dowe-language-server` over stdio.

The extension is maintained here directly. It is not generated from, embedded in, or installed through another Dowe repository.

## Repository Split

Dowe editor support is intentionally split across sibling repositories:

| Repository    | Responsibility                                                                                                              |
| ------------- | --------------------------------------------------------------------------------------------------------------------------- |
| `../dowe-lsp` | Rust `dowe-language-server`, diagnostics, completions, auto-import code actions, formatting, hover, symbols, navigation, and semantic editor behavior |
| `../dowe-zed` | Zed language extension adapter, Tree-sitter grammar, Zed queries, `extension.toml`, and dev-extension install surface |
| `../dowe-zed/icons` | Separate `dowe-icons` icon theme extension published from this repository |

Keep semantic language behavior in `dowe-language-server`. This repository should only own Zed integration, grammar, highlighting, structure, packaging, and local extension installation.

## Requirements

- Zed with Rust extension development support.
- Rust installed through `rustup`.
- The `wasm32-wasip2` Rust target for local adapter builds.

The extension does not require Node.js, `node_modules`, npm, Prettier, or ESLint.

## Local Development

Install the Rust target used by Zed extensions if it is not already present:

```sh
rustup target add wasm32-wasip2
```

Install the local language server after changing Dowe compiler or language APIs:

```sh
cd ../dowe-lsp
cargo check -p dowe_language_server
cargo install --path crates/language_server --force
cd ../dowe-zed
```

Regenerate and validate the grammar after changing `tree-sitter-dowe/grammar.js`:

```sh
cd tree-sitter-dowe
tree-sitter generate
tree-sitter test
cd ..
./scripts/bootstrap-grammar-repo.sh
```

The bootstrap script creates `.zed-dev/tree-sitter-dowe.git` from the bundled `tree-sitter-dowe` directory and updates the grammar `rev` in `extension.toml`. Run it again after changing the grammar.

Build the extension adapter:

```sh
cargo check --target wasm32-wasip2
```

Install the extension in Zed with `zed: install dev extension` and select this repository directory.

After replacing the local language-server binary or changing the grammar rev, restart the Dowe language server or reload the Zed window. If Zed still uses stale grammar state, reinstall the dev extension from this repository.

The separate `dowe-icons` extension provides the `Dowe Icons Dark` and `Dowe Icons Light` icon themes. Select one from Zed's icon theme selector to use the Dowe logo for `.dowe` files in the project panel.

To import an unresolved exact symbol, place the cursor on it and open Zed code actions with `Command + .` on macOS or `Control + .` on Windows and Linux. The language server offers one canonical project-root import such as `@/views/...` or `@/server/...` for each matching `.dowe` export under the nearest ancestor containing `main.dowe`.

Run local validation:

```sh
./scripts/check.sh
```

## View Syntax

The grammar recognizes the built-in view components, including `Section`, `AppBar`, `Footer`, `BottomBar`, `SideNav`, `RailNav`, `Sidebar`, `NavMenu`, `Scaffold`, `Tabs`, `Drawer`, `Brand`, `Input`, `Slider`, `Dropzone`, `Select`, `Option`, `Video`, `Audio`, `Image`, `Accordion`, `AvatarGroup`, `Carousel`, `ChatBox`, `Checkbox`, `Color`, `Date`, `DateRange`, `Empty`, `Marquee`, `TypeWriter`, `RichText`, `Record`, `ToggleGroup`, `Collapsible`, `Countdown`, `Map`, `RadioGroup`, `Toggle`, `ToggleTheme`, `Fab`, `fabAction`, and `Divider`. Completion and diagnostic support for their props is provided by `dowe-language-server`.

```text
AppBar variant:"soft" scheme:"surface" bordered:true boxed:true
  start
    Text
      "Dowe"
  center
    Text
      "Layout"
  end
    Button href:"/blogs" variant:"soft" scheme:"tertiary"
      "Blogs"
Input label:"Email" placeholder:"name@example.com" labelFloating:true variant:"outlined" scheme:"primary"
Select label:"Role" placeholder:"Choose a role" labelFloating:true variant:"soft" scheme:"secondary"
  Option value:"admin" label:"Administrator" description:"Manage users"
  Option value:"viewer" label:"Viewer"
Video src:"https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8" aspect:"horizontal" scheme:"surface"
Divider orientation:"vertical" scheme:"primary"
ToggleTheme variant:"soft" scheme:"secondary"
Slider bind:volume min:0 max:100 step:5 label:"Volume" scheme:"warning"
Dropzone accept:"image/*" label:"Images" placeholder:"Drop images" variant:"outlined" scheme:"surface"
RichText
  mark text:"Launch" style:"grad" scheme:"primary"
ToggleGroup selected:"map" scheme:"secondary"
  item id:"list" label:"List"
  item id:"map" label:"Map"
Collapsible label:"Details" defaultOpen:true
  Text
    "Body"
Countdown target:"2030-01-01T00:00:00Z" size:"md"
Map centerLat:4.7109 centerLng:-74.0721 height:"360px"
  marker id:"office" lat:4.7109 lng:-74.0721 label:"Office" icon:"start"
Fab icon:"settings" label:"Actions"
  fabAction label:"Docs" icon:"link" href:"/docs"
Drawer open:drawerOpen position:"start" variant:"soft" scheme:"surface" show:{ xs:true md:false }
  header
    Title
      "Menu"
  body
    SideNav variant:"soft" scheme:"surface"
  footer
    Text
      "Signed in"
Tabs variant:"pills" scheme:"primary" position:"top"
  tab id:"overview" label:"Overview"
    Text
      "Overview"
```

`AppBar`, `Footer`, and `BottomBar` use direct `start`, `center`, and `end` region blocks. `Scaffold` uses `appBar`, `start`, required `main`, `end`, `bottomBar`, and optional `overlays` regions. `NavMenu` recognizes `item`, `submenu`, `megamenu`, `icon`, and megamenu `content` blocks. `Drawer` recognizes direct `header`, `body`, and `footer` regions plus bare Signal `open`, `position`, `variant`, `scheme`, close-control flags, and common responsive `show`; direct children without a Drawer region are treated as body content. `Tabs` recognizes direct `tab` blocks with quoted `id` and `label` props. `Accordion` recognizes direct `item` blocks. `Carousel` recognizes direct `slide` blocks and completes `simple`, `snapping`, `masonry`, `rtl`, `sticky`, `controls`, `dots`, `thumbnails`, `coverFlow`, `slideshow`, `stories`, `smartStack`, `cardStack`, and `flipbook` for quoted `variant`. `RadioGroup` recognizes direct `item` options plus quoted `orientation`, `ToggleGroup` recognizes direct `item` options, `RichText` recognizes direct `mark` entries, `Map` recognizes `marker` and `waypoint` entries, and `Fab` recognizes direct `fabAction` entries. `Input` recognizes `label`, `placeholder`, and `labelFloating` through language-server support. `Slider` recognizes numeric `bind`, `min`, `max`, `step`, `label`, `scheme`, and `size`. `Dropzone` recognizes `accept`, `multiple`, `maxSize`, labels, variants, and schemes. `Select` recognizes the same visual props plus `bind`, `variant`, and `scheme`; direct `Option` children use `value`, `label`, and optional `description`. `Video` recognizes `src`, `poster`, `autoplay`, `aspect`, `variant`, and `scheme`; `Audio` and the media/display/form controls use `scheme` for visual family. `Divider` recognizes `orientation` and `scheme`. Every static string prop uses double quotes, and `Text`, `Title`, and `Button` visible copy uses one direct double-quoted string child, so the language server flags `Option value:admin`, `Path fill:none`, `variant:outlined`, `scheme:primary`, and `Title` children such as `header`. Resolved references such as `bind:profile.role`, `open:drawerOpen`, and `onClick:save` remain bare.

`onClick:action` invokes a declared action. Explicit inline state updates use an object such as
`onClick:{ set:drawerOpen value:!drawerOpen }`, `onClick:{ set:counter add:1 }`, or
`onClick:{ set:message append:"!" }`. The grammar already recognizes object values; the language
server provides the shared compiler validation for targets and operation types.

## Language Server

The published extension must not depend on a private Dowe checkout. The adapter uses an explicit Zed LSP binary setting when present, then a `dowe-language-server` binary on `PATH`, and otherwise asks Zed to download `dowe-language-server` from public release assets on `usedowe/dowe-zed`. The language-server source remains in `../dowe-lsp`; release assets attached to the extension are built from that repository.

Each release that should provide language-server features needs these assets:

```text
dowe-language-server-darwin-aarch64.tar.gz
dowe-language-server-darwin-x86_64.tar.gz
dowe-language-server-linux-aarch64.tar.gz
dowe-language-server-linux-x86_64.tar.gz
dowe-language-server-windows-aarch64.zip
dowe-language-server-windows-x86_64.zip
```

Each archive should contain the executable at its root:

- `dowe-language-server` for macOS and Linux.
- `dowe-language-server.exe` for Windows.

For local development, install the current language server on `PATH` after compiler or language API changes:

```sh
cargo install --path ../dowe-lsp/crates/language_server --force
```

## Publishing

Before publishing to the Zed extension registry, `extension.toml` must point at a public grammar source. Zed allows a Tree-sitter grammar to live in a subdirectory by using `path = "tree-sitter-dowe"`.

After committing grammar changes, prepare the manifest for publication:

```sh
./scripts/prepare-publish.sh
```

This changes the grammar entry to use `https://github.com/usedowe/dowe-zed`, the current `HEAD` commit, and `path = "tree-sitter-dowe"`.

Then open a PR to `zed-industries/extensions` that adds this repository as a submodule under `extensions/dowe` and adds the matching version to `extensions.toml`.

The same submodule can publish the separate icon theme extension with this additional registry entry:

```toml
[dowe-icons]
submodule = "extensions/dowe"
path = "icons"
version = "0.1.0"
```

## Repository Layout

| Path                                | Purpose                                                                                |
| ----------------------------------- | -------------------------------------------------------------------------------------- |
| `extension.toml`                    | Registers the Zed extension, grammar, and language server                              |
| `Cargo.toml`                        | Builds the WebAssembly extension adapter                                               |
| `src/lib.rs`                        | Starts `dowe-language-server` for Zed                                                  |
| `languages/dowe/config.toml`        | Registers `.dowe`, tab size, and grammar metadata                                      |
| `languages/dowe/*.scm`              | Tree-sitter queries for highlighting, indentation, outline, text objects, and brackets |
| `tree-sitter-dowe/grammar.js`       | Tree-sitter grammar source                                                             |
| `tree-sitter-dowe/src/parser.c`     | Generated Tree-sitter parser consumed by Zed                                           |
| `scripts/bootstrap-grammar-repo.sh` | Builds the local git mirror used by Zed dev extension installs                         |
| `scripts/prepare-publish.sh`        | Points the grammar at the public repository before publishing                          |
| `scripts/check.sh`                  | Runs local build and decoupling checks                                                 |
| `icons/extension.toml`              | Registers the separate Dowe icon theme extension                                       |
| `icons/icon_themes/dowe-icons.json` | Defines the Dowe dark and light icon themes                                             |
| `icons/assets/logo.svg`             | Provides the icon theme asset                                                           |
