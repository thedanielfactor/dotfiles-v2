#!/usr/bin/env bash
SHARED_HOME="$DOTS_DIR"/shared/home/

shared_backup_existing() {
	message "[>>] Backing up existing dotfiles to $BACKUP_LOCATION"

	mkdir -p "$BACKUP_LOCATION"/.local/share/

	# backup .config
	mv "$HOME"/.config/BetterDiscord "$BACKUP_LOCATION"/.config/
	mv "$HOME"/.config/alacritty "$BACKUP_LOCATION"/.config/
	mv "$HOME"/.config/astronvim "$BACKUP_LOCATION"/.config/
	mv "$HOME"/.config/bat "$BACKUP_LOCATION"/.config/
	mv "$HOME"/.config/btop "$BACKUP_LOCATION"/.config/
	mv "$HOME"/.config/davmail "$BACKUP_LOCATION"/.config/
	mv "$HOME"/.config/fastfetch "$BACKUP_LOCATION"/.config/
	mv "$HOME"/.config/fish "$BACKUP_LOCATION"/.config/
	mv "$HOME"/.config/kitty "$BACKUP_LOCATION"/.config/
	mv "$HOME"/.config/micro "$BACKUP_LOCATION"/.config/
	mv "$HOME"/.config/nvim "$BACKUP_LOCATION"/.config/
	mv "$HOME"/.local/share/nvim "$BACKUP_LOCATION"/.local/share/nvim/
	mv "$HOME"/.config/ranger "$BACKUP_LOCATION"/.config/
	mv "$HOME"/.config/spicetify "$BACKUP_LOCATION"/.config/
	mv "$HOME"/.config/topgrade.toml "$BACKUP_LOCATION"/.config/

	mv "$HOME"/.gnupg "$BACKUP_LOCATION"
	mv "$HOME"/.ssh "$BACKUP_LOCATION"
	mv "$HOME"/.gitconfig "$BACKUP_LOCATION"
	mv "$HOME"/.gitconfig.functions "$BACKUP_LOCATION"
	mv "$HOME"/.gitconfig.signing "$BACKUP_LOCATION"
	mv "$HOME"/.wakatime.cfg "$BACKUP_LOCATION"
	mv "$HOME"/.wegorc "$BACKUP_LOCATION"
}

correct_ssh_permissions() {
	message "[>>] Settings $HOME/.ssh permissions"

	chmod 700 "$HOME"/.ssh
	chmod 600 "$HOME"/.ssh/*
}

install_bat_themes() {
	if [[ $(command -v bat) ]]; then
		message "[>>] Installing bat theme"
		# bat requires cache to be rebuilt to detect themes in config directory
		bat cache --build
	else
		message "[!!] bat not detected... installation instructions: https://github.com/sharkdp/bat#installation"
	fi
}

install_better_discord() {
	if [[ $(command -v betterdiscordctl) ]]; then
		message "[>>] Better discord detected... installing.."
		betterdiscordctl install
	else
		message "[!!] Better Discord not detected... installation instructions: https://docs.betterdiscord.app/users/getting-started/installation"
	fi
}

install_fish_plugins() {
	if [[ $(command -v fish) ]]; then
		message "[>>] Installing fisher..."
		fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"

		message "[>>] Installing fish plugins"
		message "[>>] DO NOT configure Tide when prompted"

		git restore "$SHARED_HOME"/.config/fish/fish_plugins

		fish -c "fisher update"
	else
		message "[!!] Fish not detected... installation instructions: https://fishshell.com/"
	fi
}

install_spicetify() {
	if [[ $(command -v spicetify) ]]; then

		message "[>>] Spicetify detected.. configuring and setting theme"

		if [[ "$OSTYPE" == "linux-gnu"* ]]; then

			message "[>>] Linux detected.. checking for spotify installations"

			# Spotify path
			if [[ -d "/opt/spotify/" ]]; then
				message "[>>] Spotify detected in /opt/spotify.. setting permissions and spotify_path"

				sudo chmod a+wr /opt/spotify
				sudo chmod a+wr /opt/spotify/Apps -R

				command -v spicetify && spicetify config spotify_path /opt/spotify/

			elif [[ -d "/usr/share/spotify" ]]; then
				message "[>>] Spotify detected in /usr/share/spotify.. settings permissions and spotify_path"

				sudo chmod a+wr /usr/share/spotify
				sudo chmod a+wr /usr/share/spotify/Apps -R

				command -v spicetify && spicetify config spotify_path /usr/share/spotify

			elif [[ -d "$HOME/.var/app/com.spotify.Client/config/spotify" ]]; then
				message "[>>] Spotify detected in "$HOME"/.var/app/com.spotify.Client/config/spotify.. settings permissions and spotify_path"

				sudo chmod a+wr "$HOME"/.var/app/com.spotify.Client/config/spotify
				sudo chmod a+wr "$HOME"/.var/app/com.spotify.Client/config/spotify/Apps -R

				command -v spicetify && spicetify config spotify_path "$HOME"/.var/app/com.spotify.Client/config/spotify
			fi

			# Preferences path
			if [[ -f "$HOME/.config.spotify/prefs" ]]; then
				message "[>>] Spotify prefs found at $HOME/.config/spotify/prefs... settings prefs_path"

				command -v spicetify && spicetify config prefs_path "$HOME"/.config/spotify/prefs

			elif [[ -f "$HOME/.var/app/com.spotify.Client/config/spotify/prefs" ]]; then
				message "[>>] Spotify prefs found at $HOME/.var/app/com.spotify.Client/config/spotify/prefs... settings prefs_path"

				command -v spicetify && spicetify config prefs_path "$HOME"/.var/app/com.spotify.Client/config/spotify/prefs
			fi
		fi

		if [[ "$OSTYPE" == "darwin"* ]]; then

			message "[>>] macOS detected.. checking for spotify installations"

			# Spotify path
			if [[ -d "/Applications/Spotify.app/" ]]; then
				message "[>>] Spotify detected in /Applications/Spotify.app/.. setting spotify_path"

				command -v spicetify && spicetify config spotify_path /Applications/Spotify.app/Contents/Resources
			fi

			# Preferences path
			if [[ -f "$HOME/Library/Application Support/Spotify/prefs" ]]; then
				message "[>>] Spotify prefs found at $HOME/Library/Application Support/Spotify/prefs... settings prefs_path"

				command -v spicetify && spicetify config prefs_path "$HOME/Library/Application Support/Spotify/prefs"
			fi
		fi

		spicetify config inject_css 1
		spicetify config replace_colors 1
		spicetify config custom_apps marketplace

		spicetify backup apply
		spicetify apply
	else
		message "[!!] Spicetify not detected... installation instructions: https://spicetify.app/docs/advanced-usage/installation/"
	fi
}

initialize_submodules() {
	message "[>>] Pulling submodules"

	git submodule update --init --recursive --remote
	git pull --recurse-submodules
}

shared_copy_configuration() {
	message "[>>] Copying shared config files"

	# copy home folder dotfiles if you dont want to use symlinks
	# cp -r "$DOTS_DIR"/shared/home/. ~

	# link files that replace contents of location
	link_locations "$SHARED_HOME"/.config/BetterDiscord "$HOME"/.config/BetterDiscord
	link_locations "$SHARED_HOME"/.config/alacritty "$HOME"/.config/alacritty
	link_locations "$SHARED_HOME"/.config/nvim "$HOME"/.config/nvim
	link_locations "$SHARED_HOME"/.config/astronvim/lua/user "$HOME"/.config/nvim/lua/user
	link_locations "$SHARED_HOME"/.config/bat "$HOME"/.config/bat
	link_locations "$SHARED_HOME"/.config/btop "$HOME"/.config/btop
	link_locations "$SHARED_HOME"/.config/davmail "$HOME"/.config/davmail
	link_locations "$SHARED_HOME"/.config/fastfetch "$HOME"/.config/fastfetch
	link_locations "$SHARED_HOME"/.config/fish "$HOME"/.config/fish
	link_locations "$SHARED_HOME"/.config/kitty "$HOME"/.config/kitty
	link_locations "$SHARED_HOME"/.config/micro "$HOME"/.config/micro
	link_locations "$SHARED_HOME"/.config/ranger "$HOME"/.config/ranger
	link_locations "$SHARED_HOME"/.config/spicetify "$HOME"/.config/spicetify
	link_locations "$SHARED_HOME"/.config/topgrade.toml "$HOME"/.config/topgrade.toml
	link_locations "$SHARED_HOME"/.gnupg "$HOME"/.gnupg
	link_locations "$SHARED_HOME"/.ssh "$HOME"/.ssh
	link_locations "$SHARED_HOME"/.face "$HOME"/.face
	link_locations "$SHARED_HOME"/.face.icon "$HOME"/.face.icon
	link_locations "$SHARED_HOME"/.gitconfig "$HOME"/.gitconfig
	link_locations "$SHARED_HOME"/.gitconfig.functions "$HOME"/.gitconfig.functions
	link_locations "$SHARED_HOME"/.gitconfig.signing "$HOME"/.gitconfig.signing
	link_locations "$SHARED_HOME"/.wakatime.cfg "$HOME"/.wakatime.cfg
	link_locations "$SHARED_HOME"/.wegorc "$HOME"/.wegorc

	# copy files that dont replace contents of location
	cp -r "$SHARED_HOME"/.fonts/ "$HOME"/.fonts/
	cp -r "$SHARED_HOME"/.local/ "$HOME"/.local/
}

shared_install() {

	# Backup
	shared_backup_existing

	# Fetch dependencies
	initialize_submodules

	# Copy config
	shared_copy_configuration
	correct_ssh_permissions

	# Installations
	shared_theme_install
}

shared_theme_install() {

	install_spicetify
	install_better_discord
	install_bat_themes
	install_fish_plugins
}
