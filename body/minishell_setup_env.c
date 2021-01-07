/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   minishell_setup_env.c                              :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: kchoi <kchoi@student.42seoul.kr>           +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2021/01/07 20:10:19 by kchoi             #+#    #+#             */
/*   Updated: 2021/01/07 20:10:22 by kchoi            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../includes/exec.h"

void	setup_oldpwd(void)
{
	int oldpwd_index;

	if ((oldpwd_index = search_in_array(g_global_env, "OLDPWD", '=')) == -1)
		g_global_env = extend_array_str(g_global_env, "OLDPWD",
		str_array_length(g_global_env));
}

void	setup_pwd(void)
{
	char set_pwd[4096];

	if (search_in_array(g_global_env, "PWD", '=') == -1)
	{
		getcwd(set_pwd, 4096);
		update_pwd(-1, set_pwd);
	}
	g_pwd_path = get_env_value("PWD");
	g_pwd_check = 0;
}

void	setup_var(char *exe)
{
	char *set_var;

	set_var = NULL;
	if (search_in_array(g_global_env, "_", '=') == -1)
	{
		set_var = (char *)malloc(sizeof(char)
		* (ft_strlen(g_pwd_path) + ft_strlen(exe) + 3));
		ft_strcpy(set_var, "_=");
		ft_strcat(set_var, g_pwd_path);
		ft_strcat(set_var, "/");
		ft_strcat(set_var, exe);
		g_global_env = extend_array_str(g_global_env, set_var,
		str_array_length(g_global_env));
	}
}

void	setup_env(char **argv, char **env, int *exit_status)
{
	g_erno = 0;
	g_child_pid = -1;
	g_global_env = duplicate_array(env, NULL, '\0');
	setup_oldpwd();
	setup_shlvl();
	setup_pwd();
	setup_var(argv[0]);
	*exit_status = 0;
	g_filtered_env = filter_env(g_global_env, NULL);
	signal(SIGINT, signal_manager);
	signal(SIGQUIT, signal_manager);
}
