# .dotfiles
These are my dotfiles. Currently I use a static colorscheme because I feel like that works for me.

## Installing
I use stow to manage my dotfiles. In order to say, use my configs for ncmpcpp, first cd into the repo directory:
```
cd .dotfiles
```

Then stow the files in your home directory
```
stow ncmpcpp
```

## Uninstalling
Since I use stow, uninstalling my dots are easy, just use 'stow -D'.
First cd in the dotfiles directory
```
cd .dotfiles
```
Then remove the ncmpcpp files
```
stow -D ncmpcpp
```
