
#include "../includes/exec.h"

void	exec_prompt(void)
{
	char *dir;
	char **split_result;

	split_result = NULL;
	if (ft_strlen(g_pwd_path) == 1
	&& g_pwd_path[0] == '/')
		dir = "/";
	else
	{
		split_result = ft_split(g_pwd_path, '/');
		dir = split_result[str_array_length(split_result) - 1];
	}
	write(1, "\033[38;5;208m", 12);
	write(1, dir, ft_strlen(dir));
	write(1, " ", 1);
	write(1, "\033[38;5;196m", 12);
	write(1, "}> ", 3);
	write(1, "\033[0m", 4);
	free_str_array(split_result);
}

int		exec_instructions(void)
{
	int status;

	status = 0;
	if (g_lst->cmd)
	{
		if (ft_strcmp(g_lst->cmd, "pwd") == 0)
			ft_pwd();
		else if (ft_strcmp(g_lst->cmd, "echo") == 0)
			ft_echo(g_lst->arg);
		else if (ft_strcmp(g_lst->cmd, "env") == 0)
			ft_env(g_lst->arg);
		else if (ft_strcmp(g_lst->cmd, "cd") == 0)
			ft_cd(g_lst->arg);
		else if (ft_strcmp(g_lst->cmd, "export") == 0)
			status = ft_export(g_lst->arg);
		else if (ft_strcmp(g_lst->cmd, "unset") == 0)
			status = ft_unset(g_lst->arg);
		else if (ft_strcmp(g_lst->cmd, "exit") != 0)
			ft_program(g_lst->cmd, g_lst->raw);
	}
	return (status);
}

void	exec_child(int is_prev_piped, int status, int w_pend, int w_pwdend)
{
	if (is_prev_piped == 1)
		status = 0;
	setup_command(status);
	if (g_lst->rdo_type != 0 || g_lst->rdc_type != 0)
		manage_redirection();
	if (ft_strcmp(g_lst->cmd, "exit") != 0)
		status = exec_instructions();
	if (g_lst->pipe == 0)
		send_env(w_pend, w_pwdend);
	else
	{
		close(w_pend);
		close(w_pwdend);
	}
	ft_exit(status);
}

int		exec_father(int exit_status, int read_pend, int read_pwdend)
{
	int ret_child;
	int	ret;

	ret = 1;
	while (ret > 0)
		ret = wait(&ret_child);
	if (WIFEXITED(ret_child))
		exit_status = WEXITSTATUS(ret_child);
	receive_env(read_pend, read_pwdend);
	g_filtered_env = filter_env(g_global_env, g_filtered_env);
	close(read_pend);
	return (exit_status);
}

int		exec_command_line(char *line, int exit_status)
{
	int *read_fd;

	if (!(read_fd = (int *)malloc(sizeof(int) * 2)))
		ft_error('\0', "Malloc", NULL, 1);
	parsing(line);
	read_fd = setup_pipe_and_process(exit_status, read_fd);
	exit_status = exec_father(exit_status, read_fd[0], read_fd[1]);
	free(read_fd);
	return (exit_status);
}
