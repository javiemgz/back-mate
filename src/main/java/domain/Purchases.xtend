package domain

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Purchases {
	Flight flight
	Seat seat
	double amount
}