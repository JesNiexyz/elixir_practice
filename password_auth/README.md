# elixir_practice

RealDealApi is a Phoenix project for practicing Elixir.

## Run locally

- Run `mix setup` to install and set up dependencies.
- Start the server with `mix phx.server` or `iex -S mix phx.server`.

Visit [localhost:4000](http://localhost:4000) in your browser.

## Run from the NixOS VM with Docker Postgres

In this setup, Phoenix runs in a NixOS VM and PostgreSQL runs in the `bs_db`
Docker container on the Windows host. The app's `localhost` is the VM, not the
Windows host, so set `DEV_DB_HOST` to the Windows host's reachable Tailscale IP.

1. On Windows, start Docker Desktop and check that the database container is
	 running and publishes port 5432:

	 ```powershell
	 docker start bs_db
	 docker port bs_db 5432/tcp
	 ```

2. In the VM's ignored `.env` file, set the host and the database credentials
	 configured for the container. For example:

	 ```env
	 DEV_DB_HOST=<windows-host-tailscale-ip>
	 DEV_DB_USERNAME=<postgres-user>
	 DEV_DB_PASSWORD=<postgres-password>
	 ```

	 Keep `.env` private; it is ignored by Git. Mix does not load it by itself.

3. Connect to the VM and load `.env` into that shell. From Windows, the SSH
	 command is `ssh jessenielson@<vm-tailscale-ip>`.

	 ```sh
	 cd ~/Downloads/elixir_practice
	 set -a
	 source .env
	 set +a
	 nc -vz "$DEV_DB_HOST" 5432
	 ```

	 A successful `nc` check confirms network access to port 5432, but does not
	 verify the database username or password.

4. On first setup, create the app database and run migrations. Later, run
	 migrations only when the project adds new ones:

	 ```sh
	 mix ecto.create
	 mix ecto.migrate
	 ```

5. Start Phoenix:

	 ```sh
	 mix phx.server
	 ```

	 From Windows, open `http://<vm-tailscale-ip>:4000` while connected to the
	 same Tailscale network.

### Connection troubleshooting

- `connection refused` for `localhost:5432` means PostgreSQL is not listening
	inside the VM. Here it runs on the Windows host in Docker, so use the host's
	reachable address instead.
- A timeout means the address or network path is wrong, or a firewall blocks
	the port. The VM's default gateway was not the database host; the Windows
	host's Tailscale IP was reachable on port 5432.
- `password authentication failed` means the VM reached PostgreSQL, but the
	credentials do not match the container's database user. Check
	`DEV_DB_USERNAME` and `DEV_DB_PASSWORD` in `.env`.
- “The database ... has already been created” and “Migrations already up” mean
	database setup succeeded; they are not errors.
- A missing `~p` route warning or port 4000 already in use is separate from
	PostgreSQL connectivity. The route warning does not stop the server; a port
	conflict requires stopping the other server or choosing another port.

Ready to run in production? See the [Phoenix deployment guides](https://phoenix.hexdocs.pm/deployment.html).

## Learn more

- [Phoenix website](https://www.phoenixframework.org/)
- [Phoenix guides](https://phoenix.hexdocs.pm/overview.html)
- [Phoenix docs](https://phoenix.hexdocs.pm)
- [Phoenix forum](https://elixirforum.com/c/phoenix-forum)
- [Phoenix source](https://github.com/phoenixframework/phoenix)
