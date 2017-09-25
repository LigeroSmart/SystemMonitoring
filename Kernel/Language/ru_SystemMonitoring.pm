# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ru_SystemMonitoring;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # SysConfig
    $Self->{Translation}->{'Basic mail interface to System Monitoring Suites. Use this block if the filter should run AFTER PostMasterFilter.'} =
        'Основной почтовый интерфейс для System Monitoring Suites. Используйте этот блок, если фильтр должен выполняться ПОСЛЕ PostMasterFilter.';
    $Self->{Translation}->{'Basic mail interface to System Monitoring Suites. Use this block if the filter should run BEFORE PostMasterFilter.'} =
        'Основной почтовый интерфейс для System Monitoring Suites. Используйте этот блок, если фильтр должен выполняться ДО PostMasterFilter.';
    $Self->{Translation}->{'Define Nagios acknowledge type.'} = 'Определите тип подтверждения Nagios.';
    $Self->{Translation}->{'Dutch'} = '';
    $Self->{Translation}->{'HTTP'} = 'HTTP';
    $Self->{Translation}->{'Link an already opened incident ticket with the affected CI. This is only possible when a subsequent system monitoring email arrives.'} =
        'Свяжите уже открытый инцидент с затронутым CI. Это возможно только в том случае, если приходит сообщение о последующей проверке электронной почты.';
    $Self->{Translation}->{'Name of the Dynamic Field for Host.'} = 'Имя динамического поля для хоста.';
    $Self->{Translation}->{'Name of the Dynamic Field for Service.'} = 'Имя динамического поля для службы.';
    $Self->{Translation}->{'Named pipe acknowledge command.'} = 'Команда подтверждения пайпа.';
    $Self->{Translation}->{'Named pipe acknowledge format for host.'} = 'Формат подтверждения именованного пайпа для хоста.';
    $Self->{Translation}->{'Named pipe acknowledge format for service.'} = 'Формат подтверждения именованного пайпа для сервиса.';
    $Self->{Translation}->{'Set the incident state of a CI automatically when a system monitoring email arrives.'} =
        'Автоматически задавать состояние инцидента для CI, когда приходит сообщение системы мониторинга.';
    $Self->{Translation}->{'The HTTP acknowledge URL.'} = 'URL-адрес подтверждения HTTP.';
    $Self->{Translation}->{'The HTTP acknowledge password.'} = 'Пароль подтверждения HTTP.';
    $Self->{Translation}->{'The HTTP acknowledge user.'} = 'Пользователь с подтверждением HTTP.';
    $Self->{Translation}->{'Ticket event module to send an acknowledge to Nagios.'} = 'Модуль события заявки для отправки подтверждения в Nagios.';
    $Self->{Translation}->{'pipe'} = 'pipe';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
