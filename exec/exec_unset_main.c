/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   exec_unset_main.c                                  :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: kchoi <kchoi@student.42seoul.kr>           +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2021/01/07 20:15:06 by kchoi             #+#    #+#             */
/*   Updated: 2021/01/07 20:15:07 by kchoi            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../includes/exec.h"

int		is_unset(int *index_array, int index)
{
	int count;

	count = 0;
	while (index_array[count] != -1)
	{
		if (index_array[count] == index)
			return (1);
		count++;
	}
	return (0);
}

char	**clear_env(char **input_array, int *index_array)
{
	int		add_count;
	int		array_count;
	char	**output_array;

	add_count = 0;
	array_count = 0;
	if (!(output_array = (char **)malloc(sizeof(char *)
	* (str_array_length(input_array) - int_array_length(index_array) + 1))))
		ft_error('\0', "Malloc", NULL, 1);
	while (input_array[array_count])
	{
		if (!(is_unset(index_array, array_count)))
		{
			output_array[add_count] = ft_strdup(
			input_array[array_count]);
			add_count++;
		}
		array_count++;
	}
	output_array[add_count] = NULL;
	free_str_array(input_array);
	return (output_array);
}

int		*create_unset_index_array(char **input_array)
{
	int	index;
	int	add_count;
	int	array_count;
	int	*index_array;

	if (!(index_array = (int *)malloc(sizeof(int)
	* (str_array_length(input_array) + 1))))
		ft_error('\0', "Malloc", NULL, 1);
	add_count = 0;
	array_count = 0;
	while (input_array[array_count])
	{
		if ((index = search_in_array(g_global_env
		, input_array[array_count], '=')) >= 0)
		{
			index_array[add_count] = index;
			add_count++;
		}
		array_count++;
	}
	index_array[add_count] = -1;
	return (index_array);
}

int		ft_unset(char **args)
{
	int	status;
	int	*index_array;

	status = 0;
	if (args[0])
	{
		status = verify_unset_var(args);
		index_array = create_unset_index_array(args);
		g_global_env = clear_env(g_global_env, index_array);
		free_int_array(index_array);
	}
	return (status);
}
