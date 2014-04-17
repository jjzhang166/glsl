//by @c5h12

//How pac-man's mouth _really_ looks in 3d

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;

vec3 rotX(vec3 p,float a){
	float s=sin(radians(a)), c=cos(radians(a)); 
	return vec3(p.x,p.y*c-s*p.z,p.y*s+c*p.z);
}

vec3 rotY(vec3 p,float a){
	float s=sin(radians(a)), c=cos(radians(a)); 
	return vec3(p.z*s+p.x*c,p.y,p.z*c-p.x*s);
}

vec3 rotZ(vec3 p,float a){
	float s=sin(radians(a)), c=cos(radians(a)); 
	return vec3(p.x*c-s*p.y,p.x*s+c*p.y,p.z);
}

float sphere( vec3 p, float r ) {
	return length(p) - r;
}

float cube( vec3 p, vec3 s ) {
	return length(max( abs(p) - s, 0.0) );
}

float fakeEllipsoid( vec3 p, vec3 s ) {
	vec3 lp = p / s;
	vec3 ep = normalize(lp) * s;
	return length(p - ep) * sign(length(lp) - 1.0);
}

float torus( vec3 p, vec3 rra ) {
	float sita = atan(p.y, p.x);
	vec3 q;
	
	if( abs(sita) < rra.z ) {
		q = vec3( length(p.xy) - rra.x, p.z, 0.0 );
	} else {
		p.y = abs(p.y);
		q = p - vec3( cos(rra.z), sin(rra.z), 0.0 ) * rra.x;
	}
	return length(q) - rra.y;
}

float cylinder( vec3 p, vec2 rh ) {
	vec2 cp = vec2( length(p.xz), p.y );
	return length( max(abs(cp) - rh, 0.0) );
}

float scene( vec3 p, out vec4 color ) {
	const float melt = 0.008;
	const float meltmax = 0.0001;
	
	vec2 mousepos = (mouse - vec2(0.5)) * 2.0;
	
	//transforms
	//p = rotX( p, mousepos.y * 60.0 );
	p = rotY( p, time * 10.0 + mousepos.x * -180.0 );
	p -= vec3(0.0, -0.1, 0.0);
	
	//animation timer
	float anim = clamp( pow( sin(time * 3.14159 / 3.0), 3.0 ) * 1.2, -1.0, 1.0 );
	
	if( p.y > 0.0 ) {
		p = rotZ( p, p.y * -6.0 * anim );	// bend
	}
	
	vec3 mrrp = vec3( abs(p.x), p.y, p.z );
	
	float d0,d5 = 0.0;
	//body
	d0 += 1.0/ max(meltmax, sphere( mrrp - vec3(0.0, 0.55,-0.03 + melt), 0.5 ));
	
	//leg cylinder( p - vec3(0.0, -0.72, 0.0), vec2(1.0, 0.1) )
	d0 += 1.0 / max(meltmax, cylinder( mrrp - vec3(0.2, -0.08, 0.0), vec2(0.01, 0.14) ) - 0.06);
	d5 += 1.0 / max(meltmax, cylinder( mrrp - vec3(0.2, -0.42, 0.0), vec2(0.08, 0.14) ) - 0.06);
	d5 += 1.0 / max(meltmax, cylinder( mrrp - vec3(0.2, -0.53, 0.22), vec2(0.12, 0.12) ) - 0.02);
	
	//arm
	const float armr = 0.45;
	vec2 armangle = vec2(40.0);
	vec2 armror = vec2(-20.0);
	armangle.y = radians(armangle.x);
	armror.y = radians(armror.x);
	
	vec3 armpivot = rotX( mrrp - vec3(0.0, 0.5, 0.0), max(anim * sign(p.x), 0.0) * 180.0 );
	
	vec3 armp = armpivot - vec3(0.1, -sin((armangle - armror).y) * armr, 0.0);
	d0 += 1.0 / max(meltmax, torus( rotZ(armp, armror.x), vec3(armr, 0.04, armangle.y) ));
	vec3 handp = armp - rotZ( vec3(armr, 0.0, 0.0), (-armangle - armror).x );
	d0 += 1.0 / max(meltmax, fakeEllipsoid( rotZ(handp, (armangle + armror).x), vec3(0.05, 0.07, 0.07) ));
	
	//nose
	d0 += 1.0 / max(meltmax, fakeEllipsoid( mrrp - vec3(0.0, 0.5, 0.58), vec3(0.05, 0.05,0.095)));	
	
	d0 = 1.0 / d0 - melt;
	d5 = 1.0 / d5 - melt;
	
	//eye
	float d1 = sphere( mrrp - vec3(0.13, 0.7, 0.35 + melt), 0.14 );
	
	
	//teeth
	const float teethscale = 0.14;
	vec3 teethp = mrrp - vec3(0.0, 0.4, 0.22 + melt);
	teethp.y = abs(teethp.y);
	teethp /= teethscale;
	teethp.x = fract(teethp.x);
	float d2 = teethscale * (cube( rotZ(teethp - vec3(0.5, 1.8, 0.0), 45.0), vec3(0.4, 0.4, 0.03)) - 0.02);
	
	//mouth
	float d3 = cube( mrrp - vec3(sin(time*4.)/8.-.31, 0.25, 0.43 + melt), vec3(0.4, mix(0.08,0.9,mrrp.x*mrrp.x*1.5), 0.15)) - 0.04;
	
	vec4 d0col;
	if( d0 > -d3 ) {
		d0col = vec4(1.0, 1.0, 0.0, 0.6);	//body
	}
	else {
		d0 = -d3;
		d0col = vec4(.0, 0.1, 0.05, 0.1);	//mouth
	}
	//d0 = max(d0, -d3);
	d2 = max(d2, d3);
	
	vec4 col;
	float d;
	if( d0 < d1 ) {	//body
		d = d0;
		col = d0col;
	}
	else {	//eye
		d = d1;
		col = vec4(0.03, 0.03, 0.03, 1.0);
	}
	
	/*if( d2 < d ) {	//teeth
		d = d2;
		col = vec4(0.9, 0.9, 0.9, 0.5);
	}*/

	if(d5 < d){
		d = d5;
		col = vec4(1.0, 0.0, 0.0, 1.0);	
	}	
		

	// base
	float dbase = cylinder( p - vec3(0.0, -0.72, 0.0), vec2(1.0, 0.1) ) - 0.03;
	if( dbase < d ) {
		d = dbase;
		col = vec4(0.9, 0.9, 0.6, 0.4);
	}
	

	
	color = col;
	
	return d;
}

vec3 sceneNormal( vec3 p ) {
	const vec3 eps = vec3(0.001, 0.0, 0.0);
	vec3 norm;
	vec4 c;
	norm.x = scene( p + eps.xyz, c ) - scene( p - eps.xyz, c );
	norm.y = scene( p + eps.zxy, c ) - scene( p - eps.zxy, c );
	norm.z = scene( p + eps.yzx, c ) - scene( p - eps.yzx, c );
	return normalize(norm);
}

float ambientOcculution( vec3 p, vec3 n ) {
    const int steps = 3;
    const float delta = 0.2;

	vec4 c;
    float a = 0.0;
    float weight = 2.0;
    for( int i = 1; i <= steps; i++ ) {
        float d = (float(i) / float(steps)) * delta; 
        a += weight*(d - scene(p + n*d, c));
        weight *= 0.5;
    }
    return clamp(1.0 - a, 0.0, 1.0);
}

vec3 shading( vec3 pos, vec3 eyev, vec3 norm, vec4 col ) {
	const vec3 litpos = vec3(8.0, 10.0, 20.0);
	
	vec3 lv = normalize(litpos - pos);
	vec3 hv = normalize(eyev + lv);
	
	float nl = max(dot(norm, lv), 0.0);
	float nv = max(dot(norm, eyev), 0.0);
	float minnaert = 1.0 - max(-col.a, 0.0);
	
	float diffuse = pow(nl, minnaert) * pow(1.0 - nv, 1.0 - minnaert) + 0.2;
	float specular = pow(max(dot(norm, hv), 0.0), 160.0) *col.a;
	
	float ao = ambientOcculution( pos, norm );
	
	//return vec3(ao);
	return col.rgb * diffuse * ao + specular;
}

void main(void) {
	vec3 rgb;
	vec2 screen = (gl_FragCoord.xy - resolution * 0.5) / resolution.yy * 2.0;
	
	vec3 raydir = normalize( vec3( screen, -4.0 ) );
	vec3 raypos = vec3( 0.0, 0.0, 4.5 );
	vec4 color;
	float d;
	bool ishit = false;
	
	for( int i = 0; i < 64; i++ ) {
		d = scene(raypos, color);
		if( d < 0.01 ) {
			ishit = true;
			break;
		}
		raypos += raydir * d;
	}
	
	if( ishit ) {
		vec3 n = sceneNormal( raypos );
		rgb = shading( raypos, -raydir, n, color );
	}
	else {
		rgb = mix( vec3(0.7, 1.0, 0.5), vec3(0.5, 0.7, 1.0), gl_FragCoord.y / resolution.y );
	}
	
	gl_FragColor = vec4( rgb, 1.0 );
}