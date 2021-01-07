
#include "../includes/exec.h"

void	ft_program(char *cmd, char **args)
{
	if (cmd[0] == '.' || cmd[0] == '/')
	{
		if (execve(cmd, args, g_global_env) == -1)
			ft_error('\0', cmd, "No such file or directory", 127);
	}
	else
		ft_builtins(cmd, args);
}
