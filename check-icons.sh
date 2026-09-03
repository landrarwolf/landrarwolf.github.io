#!/bin/sh
set -eu

user=linjunchao
domain=hust.edu.cn
email="$user@$domain"

for page in index.html en/index.html; do
  count=$(grep -o '<svg class="link-chip-icon"' "$page" | wc -l | tr -d '[:space:]')
  [ "$count" -eq 4 ] || { echo "$page: expected 4 profile SVGs, found $count" >&2; exit 1; }
  grep -Fq 'aria-hidden="true" focusable="false"' "$page"
  ! grep -Eq '<span class="link-chip-icon"[^>]*>(@|GH|CV|P)</span>' "$page"
  grep -Fq '<a href="#contact"><svg class="link-chip-icon"' "$page"
  grep -Fq 'href="https://github.com/landrarwolf"' "$page"
  grep -Fq 'href="/cv/"' "$page"
  grep -Fq 'href="#publications"' "$page"
  grep -Fq '<span>Email</span>' "$page"
  grep -Fq '<span>GitHub</span>' "$page"
  grep -Fq '<span>CV</span>' "$page"
  grep -Fq '<span>Publications</span>' "$page"
  email_count=$(grep -o '<span id="email"></span>' "$page" | wc -l | tr -d '[:space:]')
  [ "$email_count" -eq 1 ] || { echo "$page: expected one runtime email span, found $email_count" >&2; exit 1; }
  grep -Fq 'const user = "linjunchao";' "$page"
  grep -Fq 'const domain = "hust.edu.cn";' "$page"
  grep -Fq 'const email = `${user}@${domain}`;' "$page"
  grep -Fq 'document.getElementById("email").textContent = email;' "$page"
  ! grep -Fq "$email" "$page"
  ! grep -Fq 'mail''to:' "$page"
done

grep -Fq 'Bootstrap Icons v1.13.1' README.md
grep -Fq 'https://github.com/twbs/icons/blob/v1.13.1/LICENSE' README.md
grep -Fq 'GitHub Primer Octicons v19.18.0' README.md
grep -Fq 'https://github.com/primer/octicons/blob/v19.18.0/LICENSE' README.md

echo 'Icon source checks passed.'
