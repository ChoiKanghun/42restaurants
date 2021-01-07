/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   minishell.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: kchoi <kchoi@student.42seoul.kr>           +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2021/01/07 20:09:17 by kchoi             #+#    #+#             */
/*   Updated: 2021/01/07 20:29:02 by kchoi            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../includes/exec.h"

int	main(int argc, char **argv, char **env)
{
	int		ret_gnl;
	int		exit_status;
	char	*line;

	(void)argc;
	(void)argv;
	setup_env(argv, env, &exit_status);
	while (1)
	{
		exec_prompt();
		ret_gnl = get_next_line(0, &line);
		if (line && line[0] && ret_gnl == 1)
			exit_status = exec_command_line(line, exit_status);
		else if (ret_gnl == 0)
			quit_shell_eof(line, exit_status);
		free_command_line(line);
	}
}
