#include "../includes/exec.h"

void	quit_shell_eof(char *line, int exit_status)
{
	free_str(&line);
	write(1, "exit\n", 5);
	ft_exit(exit_status);
}

void	free_command_line(char *line)
{
	free_str(&line);
	free_lst();
	g_child_pid = -1;
}
