/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   list_utils_2.c                                     :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: kchoi <kchoi@student.42seoul.kr>           +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2021/01/07 20:20:07 by kchoi             #+#    #+#             */
/*   Updated: 2021/01/07 20:20:08 by kchoi            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../includes/parsing.h"

int	is_only_space(char *stock)
{
	int i;

	i = 0;
	while (stock[i])
	{
		if (stock[i] != ' ')
			return (1);
		i++;
	}
	return (0);
}

int	is_pipe(char *stock)
{
	int	i;

	i = 0;
	while (stock[i])
	{
		if (stock[i] == '|' && !is_esc(stock, i))
			return (1);
		i++;
	}
	return (0);
}
