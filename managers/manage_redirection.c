/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   manage_redirection.c                               :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: kchoi <kchoi@student.42seoul.kr>           +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2021/01/07 20:19:13 by kchoi             #+#    #+#             */
/*   Updated: 2021/01/07 20:38:50 by kchoi            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../includes/exec.h"

int		check_rdo_exec(void)
{
	int count;
	int fd_file;

	count = 0;
	if (g_lst->rdo_type != 0)
	{
		while (g_lst->rdo_filetab[count])
		{
			if ((fd_file = open(g_lst->rdo_filetab[count], O_RDONLY)) == -1)
				return (count);
			close(fd_file);
			count++;
		}
	}
	return (-1);
}

void	manage_rdo_error(int ret_check)
{
	ft_error('\0', g_lst->rdo_filetab[ret_check]
	, "No such file or directory", 1);
}

void	create_file(void)
{
	int count;
	int fd_file;

	count = 0;
	if (g_lst->rdc_filetab)
	{
		while (g_lst->rdc_filetab[count])
		{
			if (g_lst->rdc_index[count][1] == 1)
			{
				if ((fd_file = open(g_lst->rdc_filetab[count],
					O_TRUNC | O_CREAT, 0644)) == -1)
					ft_error('\0', g_lst->rdc_filetab[count], NULL, 1);
			}
			else if (g_lst->rdc_index[count][1] == 2)
			{
				if ((fd_file = open(g_lst->rdc_filetab[count],
					O_CREAT, 0644)) == -1)
					ft_error('\0', g_lst->rdc_filetab[count], NULL, 1);
			}
			close(fd_file);
			count++;
		}
	}
}

void	red_stdout_in_file(void)
{
	int fd_file;

	if (g_lst->rdc_type == 1)
	{
		if ((fd_file = open(g_lst->rdc_filename, O_WRONLY | O_TRUNC)) == -1)
			ft_error('\0', g_lst->rdc_filename, NULL, 1);
	}
	else
	{
		if ((fd_file = open(g_lst->rdc_filename, O_WRONLY | O_APPEND)) == -1)
			ft_error('\0', g_lst->rdc_filename, NULL, 1);
	}
	dup2(fd_file, STDOUT_FILENO);
	close(fd_file);
}

void	manage_redirection(void)
{
	int ret_check;

	if ((ret_check = check_rdo_exec()) != -1)
		manage_rdo_error(ret_check);
	create_file();
	if (g_lst->rdc_type != 0)
		red_stdout_in_file();
}
