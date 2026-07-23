# Deploying the Example App to Cloudflare Pages

The coflui example app is a static Flutter web build — a perfect fit for
Cloudflare Pages (free, global CDN, HTTPS automatically).

This repo ships **two GitHub Actions workflows** for a 3-tier deploy strategy:

| Trigger | Target | Purpose |
|---------|--------|---------|
| `git push tag vX.Y.Z` | `coflui.pages.dev` | **Production** — stable URL for sharing |
| `git push origin develop` | `coflui-preview.pages.dev` | **Preview** — always latest |
| Open a PR → develop | `<branch>.coflui-preview.pages.dev` | **PR preview** — per-branch |

---

## One-time setup

### 1. Create the Cloudflare Pages projects

Run locally (you'll be prompted to authenticate once):

```bash
# Production project
npx wrangler pages project create coflui --production-branch=main

# (Optional) separate preview project
npx wrangler pages project create coflui-preview --production-branch=develop
```

> The workflows use `--project-name=coflui` for both. CF Pages isolates
> production vs preview deployments by `--branch` automatically, so a single
> project is fine. Create `coflui-preview` only if you want a fully separate
> domain.

### 2. Create the API token

1. Go to **dash.cloudflare.com → My Profile → API Tokens → Create Token**
2. Use the **"Edit Cloudflare Workers"** template, or a custom token with:
   - Account → Cloudflare Pages → **Edit**
3. Copy the token value.

### 3. Add repository secrets

In **GitHub → repo → Settings → Secrets and variables → Actions → New secret**:

| Secret name | Value |
|-------------|-------|
| `CLOUDFLARE_API_TOKEN` | (token from step 2) |
| `CLOUDFLARE_ACCOUNT_ID` | Your CF account ID (find it in the CF dashboard URL or Pages project) |

---

## Usage

### Production release (stable URL)

```bash
# After merging develop → main (via PR), tag a release:
git checkout develop
git tag v0.3.0
git push origin v0.3.0
# → workflow deploys to https://coflui.pages.dev
```

### Preview (auto, every push to develop)

Just push to develop — the preview workflow runs automatically:

```bash
git push origin develop
# → workflow deploys to https://coflui-preview.pages.dev
```

### PR previews

Open any PR targeting develop — the bot comments the preview URL on the PR.

---

## ⚠️ The `--no-tree-shake-icons` requirement

Flutter web's icon tree-shaker needs every `IconData` to be a compile-time
constant. Coflui's `IconResolver` resolves icon names to `IconData` at **runtime**
(from JSON), which breaks the shaker. Every web build MUST use:

```bash
flutter build web --release --no-tree-shake-icons
```

The `tool/build_web.sh` helper and both workflows already include this flag.
If you see `This application cannot tree shake icons fonts…`, you forgot it.

---

## Local build + serve

```bash
# Build only
./tool/build_web.sh

# Build + serve on LAN (http://<your-ip>:5678)
./tool/build_web.sh --serve
```
