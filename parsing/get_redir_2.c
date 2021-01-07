/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   get_redir_2.c                                      :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: kchoi <kchoi@student.42seoul.kr>           +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2021/01/07 20:20:27 by kchoi             #+#    #+#             */
/*   Updated: 2021/01/07 20:20:28 by kchoi            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../includes/parsing.h"

int		get_rdc_type(char *str)
{
	int	i;

	i = ft_strlen(str) - 1;
	while (str[i])
	{
		if (str[i] == '>' && str[i - 1] == '>')
			return (2);
		if (str[i] == '>')
			return (1);
		i--;
	}
	return (0);
}

int		**create_index_array(char *str, char *type)
{
	int	count;
	int add_count;
	int *index_array;
	int	**global_array;

	count = 0;
	add_count = 0;
	if (ft_strcmp("rdc", type) == 0)
		count = count_rdc(str);
	else if (ft_strcmp("rdo", type) == 0)
		count = count_rdo(str);
	if (!(global_array = (int **)malloc(sizeof(int*) * (count + 1))))
		ft_error('\0', "Malloc", NULL, 1);
	while (add_count <= count)
	{
		if (!(index_array = (int *)malloc(sizeof(int) * 2)))
			ft_error('\0', "Malloc", NULL, 1);
		global_array[add_count] = index_array;
		add_count++;
	}
	return (global_array);
}

int		**complete_rdc_index(char *str, int **rdc_index, int *i, int rdc_add)
{
	if (str[*i + 1] && str[*i + 1] == '>')
	{
		rdc_index[rdc_add][1] = 2;
		*i = *i + 1;
	}
	else if (str[*i] == '>' && str[*i - 1] != '>')
		rdc_index[rdc_add][1] = 1;
	return (rdc_index);
}

void	get_rd_index(char *str, int **rdc_index, int **rdo_index, char *g_map)
{
	int i;
	int index;
	int rdc_add;
	int rdo_add;

	i = 0;
	index = 0;
	rdc_add = 0;
	rdo_add = 0;
	while (str[i])
	{
		if (str[i] == '>' && !is_esc(str, i) && g_map[i] == '0')
		{
			rdc_index[rdc_add][0] = index;
			rdc_index = complete_rdc_index(str, rdc_index, &i, rdc_add);
			index++;
			rdc_add++;
		}
		if (str[i] == '<' && !is_esc(str, i) && g_map[i] == '0')
			rdo_index[rdo_add++][0] = index++;
		i++;
	}
	rdc_index[rdc_add][0] = -1;
	rdo_index[rdo_add][0] = -1;
}
