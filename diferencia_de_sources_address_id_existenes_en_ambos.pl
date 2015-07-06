#!/bin/perl
## Comparo(source adress en las reglas y el ID ded regla) entre 2 Firewall, uno con ScreenOS y otro con JunOS
@resultadofwviejo = `grep \"set policy id\" fwOLD_config.txt | awk \'{print \$4}\'| sort | uniq`;
@resultadofwnuevo = `grep \"set security policies from-zone\" fwNEW_config.txt| awk \'{print \$9}\' | sort | uniq`;

                for $aautheri (@resultadofwnuevo) {
                        $aautheri_con_accesos{$aautheri} = 1;
                }

                for $aautheri2 (@resultadofwviejo) {
                        $aautheri_del_sistema{$aautheri2} = 1;
                }

				
                for $aautheri_accedido ( keys %aautheri_con_accesos ) {
                        if ( not exists $aautheri_del_sistema{$aautheri_accedido} ) {
								$aautheri_accedido =~ s/\s+$|^\s+//;
								chomp $aautheri_accedido;
                                print "- ID \"$aautheri_accedido\" NUEVO EN SXR\n";
                        }
                }

                for $aautheri_en_sistema ( keys %aautheri_del_sistema ) {
                        if ( not exists $aautheri_con_accesos{$aautheri_en_sistema} ) {
						        $aautheri_en_sistema =~ s/\s+$|^\s+//;
								chomp $aautheri_en_sistema;
                                print "- ID \"$aautheri_en_sistema\" FALTA EN SXR\n";
                        }
                }
				
				for $aautheri_en_sistema2 ( keys %aautheri_del_sistema ) {
                        if ( exists $aautheri_con_accesos{$aautheri_en_sistema2} ) {
								chomp $aautheri_en_sistema2;
						        $aautheri_en_sistema2 =~ s/\s+$|^\s+//;
                undef @resultadofwviejo2;
                undef @resultadofwnuevo2;
                undef $fwnuevo;
                undef $fwviejo;
                undef $aautheri42;
                undef $aautheri4;
                undef $aautheri4_del_sistema{$aautheri42};
                undef $aautheri4_con_accesos{$aautheri4};
                undef $aautheri4_accedido;
                undef $aautheri4_en_sistema;
                undef $aautheri4_del_sistema{$aautheri4_accedido};
                undef $aautheri4_con_accesos{$aautheri4_en_sistema};
                undef $splipfwviejo;
                undef $splipfwnuevo;
                undef $aautheri4_con_accesos;
                undef $aautheri4_del_sistema;
                undef %aautheri4_con_accesos;
                %aautheri4_con_accesos;
                undef %aautheri4_del_sistema;
                %aautheri4_del_sistema;

                @fwviejo = `grep -e \"policy id $aautheri_en_sistema2 from\" -A20 sfw1-adm.slo1`;
                @fwnuevo= `grep -e \"set security policies from-zone" nuevo_adm.txt|grep \"policy $aautheri_en_sistema2 match\"| grep \"source-address\"`;
				
	            

        for $fwviejo (@fwviejo) {
			 chomp $fwviejo;
			## Borro las comillas dobles
            $fwviejo =~ s/\"//ge;
            ## Borro el espacio en blanco del final de la lía
            $fwviejo =~ s/\s+$//;
            ## Borro el espacio en blanco del comienzo de la lía
            $fwviejo =~ s/^\s+//;
            ## Convierto Any en any porque en el nuevo están minúa
			$fwviejo =~ s/Any/any/ge;
			## Cambio + por _
            $fwviejo =~ s/\+/_/;
            if ( $fwviejo =~ m/exit/ ) {
                last;
            }
            elsif ( $fwviejo =~ m/^set policy id $aautheri_en_sistema2$/ ) {
            }
            elsif ( $fwviejo =~ m/^set policy id $aautheri_en_sistema2 from/ ) {
                @splipfwviejo = split( " ", $fwviejo );
                push( @resultadofwviejo2, $splipfwviejo[8] );
            }
            elsif ( $fwviejo =~ m/^set\ssrc-address\s(.*)/ ) {
			    			 ## Borro el espacio en blanco del final de la lía
            $1=~ s/\s+$//;
            ## Borro el espacio en blanco del comienzo de la lía
            $1 =~ s/^\s+//;
                push( @resultadofwviejo2, $1 );
            }
        }

        for $fwnuevo (@fwnuevo) {
			 chomp $fwnuevo;
			 ## Borro el espacio en blanco del final de la lía
            $fwnuevo =~ s/\s+$//;
            ## Borro el espacio en blanco del comienzo de la lía
            $fwnuevo =~ s/^\s+//;
            @splipfwnuevo = split( " ", $fwnuevo );
			chomp $splipfwnuevo[11];
			 ## Borro el espacio en blanco del final de la lía
            $splipfwnuevo[11] =~ s/\s+$//;
            ## Borro el espacio en blanco del comienzo de la lía
            $splipfwnuevo[11] =~ s/^\s+//;
            push( @resultadofwnuevo2, $splipfwnuevo[11] );
        }

                ## Políca del nuevo equipo
                for $aautheri4 (@resultadofwnuevo2) {
                        $aautheri4_con_accesos{$aautheri4} = 1;
                }

                ## Políca del viejo equipo y que uso como plantilla
                for $aautheri42 (@resultadofwviejo2) {
                        $aautheri4_del_sistema{$aautheri42} = 1;
                }
				
                ## Si estáal imprimo el source address
                for $aautheri4_accedido ( keys %aautheri4_con_accesos ) {
                        if ( not exists $aautheri4_del_sistema{$aautheri4_accedido} ) {
								chomp $aautheri4_accedido;
								print "- ID $aautheri_en_sistema2\n";
                                print "\t$aautheri4_accedido -> OBJEVO NUEVO O CAMBIADO EN SRX\n";
                        }
                }

                ## Si falta un source address lo imprimo
                for $aautheri4_en_sistema ( keys %aautheri4_del_sistema ) {
                        if ( not exists $aautheri4_con_accesos{$aautheri4_en_sistema} ) {
								chomp $aautheri4_en_sistema;
                                print "\t$aautheri4_en_sistema -> FALTANTE DE OBJETO EN SRX\n";
                        }
                }
                        }
                }
