if [[ ! -f /tmp/foo.txt ]]; then
    \curl -sSL https://get.rvm.io | bash
    source $HOME/.rvm/scripts/rvm
    source ~/.profile
fi

