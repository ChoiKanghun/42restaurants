/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   parsing.c                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: kchoi <kchoi@student.42seoul.kr>           +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2021/01/07 20:21:47 by kchoi             #+#    #+#             */
/*   Updated: 2021/01/07 20:21:48 by kchoi            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../includes/parsing.h"

void	parsing(char *line)
{
	char **stock;

	check(line);
	stock = split_plus(line, ';');
	list_it(stock);
	if (stock)
	{
		free(stock);
		stock = NULL;
	}
}
