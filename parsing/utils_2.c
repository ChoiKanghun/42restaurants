/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   utils_2.c                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: kchoi <kchoi@student.42seoul.kr>           +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2021/01/07 20:20:45 by kchoi             #+#    #+#             */
/*   Updated: 2021/01/07 20:20:46 by kchoi            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../includes/parsing.h"

char	**get_rdc_filetab(char *str)
{
	char	**tab;
	int		nb;
	int		i;

	if (find_rdc(str))
	{
		nb = count_rdc(str);
		if (!(tab = malloc(sizeof(char*) * nb + 1)))
			ft_error('\0', "Malloc", NULL, 1);
		i = 1;
		while (i <= nb)
		{
			tab[i - 1] = get_rdc_name(str, i);
			i++;
		}
		tab[i - 1] = NULL;
		return (tab);
	}
	return (NULL);
}

char	*get_rdc_name(char *str, int i)
{
	char	*name;
	int		nb;
	int		y;
	int		ret;

	y = 0;
	nb = 0;
	name = NULL;
	while (nb != i && str[y])
	{
		if ((ret = is_rdc(str, y)))
			nb++;
		y++;
	}
	if (nb == i)
		name = get_name(str, y, ret);
	return (name);
}

char	*get_name(char *str, int i, int ret)
{
	char	*name;
	int		len;

	if (ret == 2)
		i++;
	while (str[i] == ' ')
		i++;
	len = i;
	while (is_name(str, i))
		i++;
	len = i - len;
	if (!(name = malloc(len + 1)))
		ft_error('\0', "Malloc", NULL, 1);
	i = i - len;
	len = 0;
	while (is_name(str, i))
		name[len++] = str[i++];
	name[len] = '\0';
	return (name);
}

int		is_name(char *str, int i)
{
	if (str[i] >= 'a' && str[i] <= 'z')
		return (1);
	if (str[i] >= 'A' && str[i] <= 'Z')
		return (1);
	if (str[i] >= '0' && str[i] <= '9')
		return (1);
	if (str[i] == '_')
		return (1);
	if (str[i] == '.')
		return (1);
	if (str[i] == '-')
		return (1);
	if (str[i] == '\'' || str[i] == '"')
		return (1);
	if (str[i] == '\\' || str[i] == '/')
		return (1);
	if (str[i] == '$')
		return (1);
	return (0);
}

char	*get_last(char **tab)
{
	int	i;

	i = 0;
	if (!tab)
		return (NULL);
	while (tab[i])
		i++;
	return (tab[i - 1]);
}
