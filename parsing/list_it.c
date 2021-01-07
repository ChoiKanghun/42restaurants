/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   list_it.c                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: kchoi <kchoi@student.42seoul.kr>           +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2021/01/07 20:20:57 by kchoi             #+#    #+#             */
/*   Updated: 2021/01/07 20:21:38 by kchoi            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../includes/parsing.h"
#include "../includes/exec.h"

static t_cont	get_content_lst(char *stock, int pipe, int i, int j)
{
	t_cont	cont;
	char	**content;

	cont = get_redir(stock);
	stock = clear_stock_rd(stock);
	content = split_plus(stock, ' ');
	cont.raw = duplicate_array(content, NULL, '\0');
	if (content[0] && content[0][0])
		cont.cmd = ft_strdup(content[0]);
	else
		cont.cmd = NULL;
	i = 1;
	while (content[i])
		i++;
	if (!(cont.arg = malloc(sizeof(char*) * i + 1)))
		ft_error('\0', "Malloc", NULL, 1);
	i = 1;
	j = 0;
	if (content[0])
		while (content[i])
			cont.arg[j++] = ft_strdup(content[i++]);
	cont.arg[j] = NULL;
	cont.pipe = pipe;
	free_str_array(content);
	return (cont);
}

static void		new_elem_lst_2(t_list *elem)
{
	t_list	*tmp;

	if (is_empty_lst())
		g_lst = elem;
	else
	{
		tmp = g_lst;
		while (tmp->next)
			tmp = tmp->next;
		tmp->next = elem;
	}
}

static void		new_elem_lst(char *stock_elem, int pipe)
{
	t_list	*elem;
	t_cont	cont;
	int		i;
	int		j;

	i = 0;
	j = 0;
	if (!(elem = malloc(sizeof(t_list))))
		ft_error('\0', "Malloc", NULL, 1);
	cont = get_content_lst(stock_elem, pipe, i, j);
	elem->cmd = cont.cmd;
	elem->arg = cont.arg;
	elem->raw = cont.raw;
	elem->rdc_type = cont.rdc_type;
	elem->rdo_type = cont.rdo_type;
	elem->rdc_filetab = cont.rdc_filetab;
	elem->rdo_filetab = cont.rdo_filetab;
	elem->rdc_filename = cont.rdc_filename;
	elem->rdo_filename = cont.rdo_filename;
	elem->rdc_index = cont.rdc_index;
	elem->rdo_index = cont.rdo_index;
	elem->pipe = pipe;
	elem->next = NULL;
	new_elem_lst_2(elem);
}

static void		list_pipe(char *stock_elem_piped)
{
	int		i;
	char	**pipe_sep;

	i = 0;
	pipe_sep = split_plus(stock_elem_piped, '|');
	free_str(&stock_elem_piped);
	while (pipe_sep[i] && is_only_space(pipe_sep[i]))
	{
		if (pipe_sep[i + 1] != NULL)
			new_elem_lst(pipe_sep[i], 1);
		else
			new_elem_lst(pipe_sep[i], 0);
		i++;
	}
	free_str_array(pipe_sep);
}

void			list_it(char **stock)
{
	int i;

	i = 0;
	while (stock[i] && is_only_space(stock[i]))
	{
		if (!is_pipe(stock[i]))
		{
			new_elem_lst(stock[i], 0);
			free_str(&stock[i]);
		}
		else
			list_pipe(stock[i]);
		i++;
	}
}
