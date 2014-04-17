#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const int d_tt = 0x01;
const int d_tr = 0x02;
const int d_tl = 0x04;
const int d_dd = 0x10;
const int d_dr = 0x20;
const int d_dl = 0x40;
const int d_cc = 0x88;

float thickness = 0.001;

float line(vec2 p, vec2 pa, vec2 pb ) {
	float d = distance(p, pa) + distance(p, pb) - distance(pa, pb);
	return 1.0-step(thickness, d);
}

float digit7(vec2 p, int spec, vec2 offset, vec2 size) {
	float d = 0.0;
	if ( spec >= d_cc ) { spec -= d_cc; d += line(p, offset + vec2 ( .0     , size.y * .5 ) , offset + vec2 ( size.x , size.y * .5 ) ); }
	if ( spec >= d_dl ) { spec -= d_dl; d += line(p, offset                                 , offset + vec2 ( .0     , size.y * .5 ) ); }
	if ( spec >= d_dr ) { spec -= d_dr; d += line(p, offset + vec2 ( size.x , .0 )          , offset + vec2 ( size.x , size.y * .5 ) ); }
	if ( spec >= d_dd ) { spec -= d_dd; d += line(p, offset                                 , offset + vec2 ( size.x , .0          ) ); }
	if ( spec >= d_tl ) { spec -= d_tl; d += line(p, offset + vec2 ( .0     , size.y * .5 ) , offset + vec2 ( .0     , size.y      ) ); }
	if ( spec >= d_tr ) { spec -= d_tr; d += line(p, offset + vec2 ( size.x , size.y * .5 ) , offset + size ); }
	if ( spec >= d_tt ) { spec -= d_tt; d += line(p, offset + vec2 ( .0     , size.y )      , offset + size ); }
	return d;
}
float digit(vec2 p, float val, vec2 offset, vec2 size) {
	val = fract(val/10.0);
	// Ugly bisect	
	if ( val < 0.5 ) {
		if ( val < 0.3 ) {
			if ( val < 0.1 )            return digit7(p, 0x77 , offset , size ); //0
			else if ( val < 0.2)        return digit7(p, 0x22  , offset , size ); //1
			else                        return digit7(p, 0xdb , offset , size ); //2
		} else {
			if ( val < 0.4 )            return digit7(p, 0xbb  , offset , size ); //3
			else               	    return digit7(p, 0xae  , offset , size ); //4
		}
	} else {
		if ( val < 0.8 ) {
			if ( val < 0.6 )            return digit7(p, 0xbd  , offset , size ); //5
			else if ( val < 0.7)        return digit7(p, 0xfd , offset , size ); //6
			else                        return digit7(p, 0x23  , offset , size ); //7
		} else {
			if ( val < 0.9 )            return digit7(p, 0xff , offset , size ); //8
			else               	    return digit7(p, 0xbf  , offset , size ); //9
		}
	}
}
float show5(vec2 p, float val, vec2 offset, vec2 size) {
	float d = 0.0;
	const int digits = 5;
	for(int i=0; i<digits; i++)  
		d += digit(p, val/pow(10.0,float(i)), offset+vec2(-float(i)*size.x - 0.03*float(i),0.0), size);
	return d;
}
float test(vec2 p) {
	float d = 0.0;
	const int digits = 10;
	for(int i=0; i<digits; i++)  
		d += digit(p, float(i), vec2(-0.1*float(i)+1.0,-0.5), vec2(0.08,0.1)); 
	for(int i=0; i<digits; i++)  
		d += digit(p, float(i)+0.99, vec2(-0.1*float(i)+1.0,-0.7), vec2(0.08,0.1));
	for(int i=0; i<digits; i++)  
		d += digit(p, float(i)-0.01, vec2(-0.1*float(i)+1.0,-0.9), vec2(0.08,0.1));
	return d;
}

void main( void ) {
	
	vec2 position = ( gl_FragCoord.xy / resolution.xy )-0.5; //[-1,1]
	position.x *= resolution.x/resolution.y; //aspect ratio
		
	float d = 0.0;
	d += show5(position*2.0, time, vec2(0.0,0.5), vec2(0.1,0.1));
	d += test(position*2.0);
	
	gl_FragColor = vec4(d);
}