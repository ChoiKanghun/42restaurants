#include "../includes/exec.h"

void	setup_parent(int *prev_fd, int *prev_pipe, int p_fd[2], int pwd_fd[2])
{
	int count;

	count = 0;
	close(p_fd[1]);
	close(pwd_fd[1]);
	if (*prev_fd >= 0)
		close(*prev_fd);
	*prev_fd = p_fd[0];
	*prev_pipe = g_lst->pipe;
	if (g_lst->cmd && ft_strcmp(g_lst->cmd, "unset") == 0)
	{
		while (g_lst->arg[count])
		{
			if (ft_strcmp(g_lst->arg[count], "PWD") == 0)
				g_pwd_check = 1;
			count++;
		}
	}
	g_lst = g_lst->next;
}

void	setup_child(int prev_fd, int prev_pipe, int p_fd[2], int pwd_fd[2])
{
	close(p_fd[0]);
	close(pwd_fd[0]);
	if (prev_fd >= 0)
	{
		if (prev_pipe == 1)
			dup2(prev_fd, STDIN_FILENO);
		close(prev_fd);
	}
	if (g_lst->pipe == 1 && g_lst->rdc_type == 0)
	{
		dup2(p_fd[1], STDOUT_FILENO);
		close(p_fd[1]);
	}
}

int		wait_for_child(int exit_status, int read_pend, int read_pwdend)
{
	int ret_pchild;

	waitpid(g_child_pid, &ret_pchild, 0);
	if (WIFEXITED(ret_pchild))
		exit_status = WEXITSTATUS(ret_pchild);
	receive_env(read_pend, read_pwdend);
	g_filtered_env = filter_env(g_global_env, g_filtered_env);
	return (exit_status);
}
