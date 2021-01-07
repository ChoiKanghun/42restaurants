/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   exec_builtins.c                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: kchoi <kchoi@student.42seoul.kr>           +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2021/01/07 20:12:15 by kchoi             #+#    #+#             */
/*   Updated: 2021/01/07 20:30:50 by kchoi            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../includes/exec.h"

int		is_builtins(char *cmd)
{
	if ((ft_strcmp(cmd, "echo") == 0)
			|| (ft_strcmp(cmd, "pwd") == 0)
			|| (ft_strcmp(cmd, "env") == 0))
		return (1);
	return (0);
}

char	**build_exec_array(char *exec, char **path_array)
{
	int		count;
	char	*exec_path;
	char	**exec_array;

	count = 0;
	if (!(exec_array = (char **)malloc(sizeof(char *)
	* (str_array_length(path_array) + 1))))
		ft_error('\0', "Malloc", NULL, 1);
	while (path_array[count])
	{
		if (!(exec_path = (char *)malloc(sizeof(char) *
		(ft_strlen(exec) + ft_strlen(path_array[count]) + 2))))
			ft_error('\0', "Malloc", NULL, 1);
		ft_strcpy(exec_path, path_array[count]);
		ft_strcat(exec_path, "/");
		ft_strcat(exec_path, exec);
		exec_array[count] = exec_path;
		count++;
	}
	exec_array[count] = NULL;
	free_str_array(path_array);
	return (exec_array);
}

char	**add_file(char **input_array, char *file)
{
	char **output_array;

	if (!(output_array = (char**)malloc(sizeof(char *) * 3)))
		ft_error('\0', "Malloc", NULL, 1);
	output_array[0] = ft_strdup(input_array[0]);
	output_array[1] = ft_strdup(file);
	output_array[2] = NULL;
	free_str_array(input_array);
	return (output_array);
}

char	**setup_builtins(char *exec)
{
	int		index_path;
	char	**split_result;
	char	**path_array;
	char	**exec_array;

	if ((index_path = search_in_array(g_global_env, "PATH", '=')) == -1)
		return (NULL);
	split_result = ft_split(g_global_env[index_path], '=');
	path_array = ft_split(split_result[1], ':');
	exec_array = build_exec_array(exec, path_array);
	free_str_array(split_result);
	return (exec_array);
}

void	ft_builtins(char *exec, char **args)
{
	int		count;
	int		ret_exec;
	char	**exec_array;

	count = 0;
	if ((exec_array = setup_builtins(exec)))
	{
		if (str_array_length(args) == 1
		&& ft_strcmp(args[0], "cat") == 0 && g_lst->rdo_filename)
			args = add_file(args, g_lst->rdo_filename);
		while (exec_array[count])
		{
			ret_exec = execve(exec_array[count], args, g_global_env);
			count++;
		}
	}
	else
		ret_exec = execve(exec, args, g_global_env);
	if (ret_exec == -1)
		ft_error('\0', exec, "command not found", 127);
}
