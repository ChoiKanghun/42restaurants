#include "../includes/exec.h"

int		transform_status(char *input_str)
{
	int					count;
	int					final_status;
	unsigned long		input_status;

	count = 0;
	input_status = 0;
	if (ft_strcmp(input_str, "-9223372036854775808") == 0)
		return (0);
	if (input_str[count] == 43 || input_str[count] == 45)
		count++;
	while (input_str[count])
	{
		if (input_str[count] < 48 || input_str[count] > 57)
			ft_error('\0', "exit", "numeric argument required", 2);
		input_status = (input_status * 10) + (input_str[count] - 48);
		count++;
	}
	if (input_status > 9223372036854775807)
		ft_error('\0', "exit", "numeric argument required", 2);
	if (input_str[0] == 45)
		final_status = (int)(256 - (input_status % 256));
	else
		final_status = (int)(input_status % 256);
	return (final_status);
}

int		ft_exit(int status)
{
	if (g_lst && g_lst->cmd && ft_strcmp(g_lst->cmd, "exit")
		== 0 && g_child_pid != 0)
	{
		write(1, "exit\n", 5);
		setup_command(status);
		if (str_array_length(g_lst->arg) == 1)
			status = transform_status(g_lst->arg[0]);
		else if (str_array_length(g_lst->arg) > 1)
		{
			transform_status(g_lst->arg[0]);
			write(1, "bash: exit: too many arguments\n", 31);
			return (1);
		}
	}
	free_str_array(g_filtered_env);
	free_str_array(g_global_env);
	free_lst();
	exit(status);
}
