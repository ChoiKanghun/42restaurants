/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   list_utils.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: kchoi <kchoi@student.42seoul.kr>           +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2021/01/07 20:19:38 by kchoi             #+#    #+#             */
/*   Updated: 2021/01/07 20:19:39 by kchoi            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../includes/parsing.h"

t_list		*new_lst(void)
{
	return (NULL);
}

int			is_empty_lst(void)
{
	if (!g_lst)
		return (1);
	return (0);
}

void		clear_lst_content(void)
{
	t_list *tmp;

	tmp = g_lst_free;
	while (g_lst_free)
	{
		free_str(&g_lst_free->cmd);
		free_str_array(g_lst_free->raw);
		free_str_array(g_lst_free->arg);
		free_str_array(g_lst_free->rdc_filetab);
		free_str_array(g_lst_free->rdo_filetab);
		free_2d_int_array(g_lst_free->rdc_index);
		free_2d_int_array(g_lst_free->rdo_index);
		g_lst_free = g_lst_free->next;
	}
	g_lst_free = tmp;
}

void		clear_lst(void)
{
	t_list *tmp;

	while (g_lst_free)
	{
		tmp = g_lst_free;
		g_lst_free = g_lst_free->next;
		free(tmp);
		tmp = NULL;
	}
}

void		free_lst(void)
{
	clear_lst_content();
	clear_lst();
}
