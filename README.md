1.	Clone the Erlang server repository and the attack script repository as given below.

	`> git clone https://github.com/jonathanraes/erlang-tlsserver>`
	`git clone https://github.com/sudharshankr/robot-detect`

2. Build the Erlang server and start the container with the help of the Dockerfile present in the directory erlang-tlsserver.
	`> docker build -t erlang-server .`
	`> docker run --publish 4000:4000 --name erlang-server erlang-server`
	
	The above server will run on port 4000 and the port 4000 on the host is forwarded tothis server.

3. Change into the directory robot-detect/docker. Install the requirements using the following command.
	`> pip install -r requirements.txt`

4. Change into the directoryrobot-detect. Run the attack by executing the attack.pyfile along with the captured pcapfile as the command-line argument as shown below, or leaving out the argument to listen on the localhost interface.
	`> python attack.py capture.pcapng`
	or
	`> python attack.py`
	
	For the interactive mode, run the python file and make a request using curl or acorrectly configured browser as described in the previous section.
