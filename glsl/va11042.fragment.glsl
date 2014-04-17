#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

vec2 decalage = vec2(.5);

vec2 coordonnees = gl_FragCoord.xy - decalage;

int cellule(vec2 position) {
	return texture2D(backbuffer, (position + decalage) / resolution.xy).a >= 1. ? 1 : 0;
}

bool life(vec2 position) {
	int moi = cellule(position);
	int nbVoisines    =
		  cellule(position + vec2(-1, 0))
		+ cellule(position + vec2(+1, 0))
		+ cellule(position + vec2(0, +1))
		+ cellule(position + vec2(0, -1))
		+ cellule(position + vec2(-1, -1))
		+ cellule(position + vec2(-1, 1))
		+ cellule(position + vec2(1, -1))
		+ cellule(position + vec2(1, 1));
	return (moi > 0 && nbVoisines == 2) || nbVoisines == 3;
}

bool test_une_cellule_toute_seule_elle_meurt() {
	return !life(vec2(1., 1.));
}

bool test_une_cellule_avec_une_copine_elle_meurt() {
	return !life(vec2(10., 1.));
}

bool test_une_cellule_avec_deux_copines_elle_vit() {
	return life(vec2(20., 1.));
}

bool test_une_cellule_avec_deux_copines_verticales_elle_vit() {
	return life(vec2(30., 1.));
}

bool test_une_cellule_avec_trois_voisins_elle_vit() {
	return life(vec2(40., 1.));
}

bool test_une_cellule_avec_quatre_voisins_elle_meurt() {
	return !life(vec2(50., 1.));
}

bool test_ca_marche_aussi_pour_les_diagonales() {
	return !life(vec2(60., 1.));
}

bool test_une_cellule_avec_trois_copines_elle_nait() { // GAGE
	return life(vec2(70., 1.));
}

bool test_du_vide_reste_vide() { // GAGE
	return !life(vec2(80, 1));
}

bool test_du_vide_malgre_deux_copines_reste_vide() {
	return !life(vec2(90, 1));
}

int nombreTests = 10;
bool executeTest(int numeroTest) {
	if(numeroTest == 0) return test_une_cellule_toute_seule_elle_meurt();
	if(numeroTest == 1) return test_une_cellule_avec_une_copine_elle_meurt();
	if(numeroTest == 2) return test_une_cellule_avec_deux_copines_elle_vit();
	if(numeroTest == 3) return test_une_cellule_avec_deux_copines_verticales_elle_vit();
	if(numeroTest == 4) return test_une_cellule_avec_trois_voisins_elle_vit();
	if(numeroTest == 5) return test_une_cellule_avec_quatre_voisins_elle_meurt();
	if(numeroTest == 6) return test_ca_marche_aussi_pour_les_diagonales();
	if(numeroTest == 7) return test_une_cellule_avec_trois_copines_elle_nait();
	if(numeroTest == 8) return test_du_vide_reste_vide();
	if(numeroTest == 9) return test_du_vide_malgre_deux_copines_reste_vide();
	return false;
}

vec4 ya(int x, int y) {
	return int(floor(coordonnees.x)) == x && int(floor(coordonnees.y)) == y ? vec4(1.0) : vec4(0.0);
}

vec4 tests( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	if(position.y > 0.9) {
		int numeroTest = int(floor(position.x * float(nombreTests)));
		
		if(!executeTest(numeroTest)) {
			return vec4(1.0, 0, 0, 0.0);
		} else {
			return vec4(0, 1.0, 0, 0.0);
		}
	} else {
		return  ya(1, 1)
			     + ya(9, 1) + ya(10, 1)
			     + ya(19, 1) + ya(20, 1) + ya(21, 1)
			     + ya(30, 0) + ya(30, 1) + ya(30, 2)
			     + ya(40, 0) + ya(40, 1) + ya(40, 2) + ya(41, 1)
			     + ya(50, 0) + ya(50, 1) + ya(50, 2) + ya(51, 1) + ya(49, 1)
			     + ya(59, 0) + ya(59, 1) + ya(59, 2) + ya(60, 1) + ya(61, 0) + ya(61, 1) + ya(61, 2)
			     + ya(69, 0) + ya(69, 2) + ya(71, 2)
			  
			     + ya(90, 0) + ya(90, 2)
			
			     + ya(100, 3) + ya(101, 3) + ya(102, 3)
			                               + ya(102, 2)
			                  + ya(101, 1);
	}
}

vec4 bruit() {
	return gl_FragCoord.x < .5 * resolution.x ? vec4(floor(50. * cos(time + 65. * gl_FragCoord.x / sin(gl_FragCoord.y)))) : vec4(0);
}

vec4 lavie() {
	return life(gl_FragCoord.xy) ? vec4(1) : vec4(0);
}

void main(void) {
	if(mouse.x < 0.1)
		gl_FragColor = tests();
	else if(mouse.x < 0.2)
		gl_FragColor = bruit();
	else {
		decalage = vec2(0.0);
		gl_FragColor = lavie();
	}
}