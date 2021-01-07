
#include "../includes/exec.h"

void	display_exec(char *exec)
{
	write(2, exec, ft_strlen(exec));
	write(2, ": ", 2);
}

void	ft_error(char symbol, char *cmd, char *msg, int status)
{
	write(2, "Minishell: ", 11);
	if (cmd && !ft_strcmp(cmd, "rd"))
		ft_error_rd(msg, symbol);
	else
	{
		if (cmd)
			display_exec(cmd);
		if (msg)
			write(2, msg, ft_strlen(msg));
		else
			write(2, strerror(g_erno), ft_strlen(strerror(g_erno)));
	}
	write(2, "\n", 1);
	free_lst();
	free_str_array(g_filtered_env);
	free_str_array(g_global_env);
	exit(status);
}
