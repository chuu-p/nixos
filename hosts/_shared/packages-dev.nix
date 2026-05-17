{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    alejandra # formatter for .nix files
    android-tools # dev
    borgbackup # backups
    caligula # burn iso to usb
    cargo # dev rust, not in dev flake for convinience
    delta # cli diff viewer, git diff uses this
    devenv # nix based dev envs
    gemini-cli # ai
    gh # github cli
    insomnia # rest client
    just # command runner
    lldb # debugger
    nodejs # js runtime
    opencode # best ai 
    opencommit # generate commit messages with ai
    presenterm # cli presentations
    tokei # count lines of code
    typst # typst compiler
    typstyle # typst formatter
    unstable.github-copilot-cli # evil tool
  ];
}
