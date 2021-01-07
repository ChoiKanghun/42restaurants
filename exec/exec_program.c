/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   exec_program.c                                     :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: kchoi <kchoi@student.42seoul.kr>           +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2021/01/07 20:16:29 by kchoi             #+#    #+#             */
/*   Updated: 2021/01/07 20:31:21 by kchoi            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */


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
