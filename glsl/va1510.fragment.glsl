//by @c5h12 - modded Pinkchocobo

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;

#define FIX_DISABLED 1

#ifdef FIX_DISABLED
float cos50=cos(radians(50.0));
float cos70=cos(radians(70.0));
float cos90=cos(radians(90.0));
#else
float cos50=sin(50.0+asin(1.0));
float cos70=sin(70.0+asin(1.0));
float cos90=sin(180.0);

float halfpi = asin(1.0);
float cos(float v){ // workaround for AMD Radeon 
	return sin(v+halfpi);
}
#endif

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
	p = rotX( p, mousepos.y * 30.0 );
	p = rotY( p, time*40.0);
	p -= vec3(0.0, -0.1, 0.0);
	
	//animation timer
	float anim = clamp( pow( sin(time * 3.14159 / 3.0), 3.0 ) * 1.2, -1.0, 1.0 );
	
	if( p.y > 0.0 ) {
		p = rotZ( p, p.y * -6.0 * anim );	// bend
	}
	
	vec3 mrrp = vec3( abs(p.x), p.y, p.z );
	
	float d0,d5,d4 = 0.0;
	//body
	d0 += 1.0/ max(meltmax, sphere( p - vec3(0.0, 0.55,-0.03 + melt), 0.5 ));
	
	//leg 
	d0 += 1.0 / max(meltmax, cylinder( mrrp - vec3(0.2, -0.08, 0.0), vec2(0.01, 0.14) ) - 0.06);
	d5 += 1.0 / max(meltmax, cylinder( mrrp - vec3(0.2, -0.42, 0.0), vec2(0.08, 0.14) ) - 0.06);
	d5 +=  1.0 / max(meltmax, fakeEllipsoid( rotY(mrrp,-25.0) - vec3(0.2, -0.53, 0.2), vec3(0.15, 0.15, 0.25)));
	//nose
	d5 += 1.0 / max(meltmax, fakeEllipsoid( mrrp - vec3(0.07, mix(0.27,0.15,mrrp.z), 0.15), vec3(0.15, 0.08, 0.2)));
	
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
	d4 += 1.0 / max(meltmax, cylinder( rotZ(handp, (armangle + armror).x), vec2(0.1, 0.02) ));
	d4 += 1.0 / max(meltmax, fakeEllipsoid( rotZ(handp+vec3(.08,.17,.0), (armangle + armror).x), vec3(0.12, 0.14,0.12) ));
	d4 += 2.0 / max(meltmax, cylinder( rotX(rotZ(handp+vec3(.15,.1,-.18), (armangle + armror).x),90.0), vec2(0.015, 0.08) ));
	
	//nose
	d0 += 1.0 / max(meltmax, fakeEllipsoid( mrrp - vec3(0.0, 0.5, 0.58), vec3(0.05, 0.05,0.095)));
	
	
	//eyebrowns
	float d6 = 1.0 / max(meltmax, cube( rotX(rotY(mrrp - vec3(0.13, 0.85, 0.30+ melt),90.0),55.0), vec3(0.005,0.1,0.1)));
	d0+=1.0 / max(meltmax, cube( rotX(rotY(mrrp - vec3(0.13, 0.8, 0.3+ melt),90.0),55.0), vec3(0.005,0.1,0.1)));
	
	d0 = 1.0 / d0 - melt;
	d4 = 1.0 / d4 - melt;
	d5 = 1.0 / d5 - melt;
	d6 = 1.0 / d6 - melt;
	
	//eye
	float d1 = fakeEllipsoid( p - vec3(0.13, 0.67, 0.35 + melt), vec3(0.07,0.19,0.14));
	float d7 = cube( rotY(rotZ(p - vec3(-0.13, 0.67, 0.35 + melt),35.0),45.0), vec3(0.07,0.12,0.14));
	
		
	//mouth
	float d3 = cube( mrrp - vec3(0.0, 0.25, 0.43 + melt), vec3(0.4, mix(0.08,0.9,mrrp.x*mrrp.x*1.5), 0.15)) - 0.04;
	
	vec4 d0col;
	if( d0 > -d3 ) {
		d0col = vec4(1.0, 1.0, 0.0, 0.6);	//body
	}
	else {
		d0 = -d3;
		d0col = vec4(.0, 0.1, 0.05, 0.1);	//mouth
	}

	
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
	
	
	if(d4 < d){
		d = d4;
		col = vec4(1.0, .5, 0.0, 1.0);	
	}	

	if(d5 < d){
		d = d5;
		col = vec4(1.0, 0.0, 0.0, 1.0);	
	}	
		
	if(d6 < d){
		d = d6;
		col = vec4(0.0, 0.0, 0.0, 1.0);	
	}
	
	
	//right eye
	if(p.z>=0.35&&p.z<=0.5){
		if(p.x>=-.24&&p.x<=-.1 && p.y<=mix(0.55,0.53,p.x*15.0)&&p.y>=mix(0.5,0.47,p.x*15.0))col=vec4(.0,.0,.0,1.0);
		if(p.x>=-.12&&p.x<=-.1 && p.y>=0.58&&p.y<=0.85)col=vec4(.0,.0,.0,1.0);
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

vec3 cellshading( vec3 pos, vec3 norm, vec3 eyev, vec4 col ) {
	const vec3 litpos = vec3(8.0, 10.0, 20.0);
	const vec3 cellshader = vec3(1.5,0.5,0.3);
	
	vec3 lv = normalize(litpos - pos);
	
	float nl = max(dot(norm, lv), 0.0);
	
	if(norm!=eyev){
		float nn = dot(norm,eyev);
		if(nn<cos(radians(75.0)))return vec3(.0,.0,.0);
	}
	
	float diffuse;
	if(nl>cos50)diffuse=cellshader.x;
	else if(nl>cos70)diffuse=cellshader.y;
	else if(nl>cos90)diffuse=cellshader.z;
		
	return col.rgb * diffuse;
}

void main(void) {
	vec3 rgb;
	vec2 screen = (gl_FragCoord.xy - resolution * 0.5) / resolution.yy * 2.0;
	vec2 mousepos = (mouse - vec2(0.5)) * 2.0;
	vec3 raydir = normalize( vec3( screen, -4.0 ) );
	vec3 raypos = vec3( 0.0, 0.0, 4.5 );
	vec3 n=vec3(.0);
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

		n = sceneNormal( raypos );
		
		if(mousepos.x>=0.0)
			rgb = cellshading( raypos, n,-raydir, color );
		else
			rgb = shading( raypos, -raydir, n, color );
	}
	else {
		rgb = mix( vec3(0.7, 1.0, 0.5), vec3(0.5, 0.7, 1.0), gl_FragCoord.y / resolution.y );
	}
	
	gl_FragColor = vec4( rgb, 1.0 );
}