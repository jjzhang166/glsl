#ifdef GL_ES
precision highp float;
#endif

// Al's Analog Bugs
// Green bugs eating blue food, loosely based on dim memories of an
// article in Scientific American many years ago...

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

// Some constants; tweak these to change life behavior
float drinkrate = 0.35;       // How fast life can deplete food at cel
float starverate = 0.0075;   // How fast life decays
float splitthreshold = 0.95;  // How alive a cel needs to be to split
float watertolife = 0.1;     // Conversion rate of food to life
float waterrate = 1.4;       // Distribution of food splotches(Higher is less food)
float instinct = 0.03;       // food-sensing fudge factor for random movement
float momentum = instinct * 2.0 - 0.0003;  // Desire to travel in a straight line if not influenced by food availability

// Red channel is command channel; may issue these commands to a living node
float stay = 1.0 / 255.0;
float goN = 2.0 / 255.0;
float goS = 3.0 / 255.0;
float goW = 4.0 / 255.0;
float goE = 5.0 / 255.0;
float splitN = 6.0 / 255.0;
float splitS = 7.0 / 255.0;
float splitW = 8.0 / 255.0;
float splitE = 9.0 / 255.0;

// Blue channel indicates how much water (food?) is at a pixel

// Green channel indicates strength of life node at that pixel (0 = dead)

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 pixel = 1./resolution;
	vec4 me = texture2D(backbuffer, position);
	float rnd1 = mod(fract(sin(dot(position + time * 0.001, vec2(14.9898,78.233))) * 43758.5453), 1.0);

	if (me.r == 0.0) {
		float prob = 1.0 - 2.0 * length(position-vec2(0.5, 0.5));
		if (prob < 0.) {prob = 0.;}
		prob = pow(prob, 2.4);
		me.b = rnd1 * rnd1 * prob;
		me.r = 0.004;
		if (length(position-vec2(0.5, 0.5)) < 0.03) {
			me.g = rnd1;
		}
	} else {
		vec4 toS = texture2D(backbuffer, position + pixel * vec2(1., 0.));
		vec4 toN = texture2D(backbuffer, position + pixel * vec2(-1., 0.));
		vec4 toE = texture2D(backbuffer, position + pixel * vec2(0., 1.));
		vec4 toW = texture2D(backbuffer, position + pixel * vec2(0., -1.));

		float dir = stay;
		float max = 0.0;

		float life = 0.0;
		if (me.r == stay) {life += me.g;}
		if (me.r == splitN) {life += me.g * 0.5;}
		if (me.r == splitS) {life += me.g * 0.5;}
		if (me.r == splitW) {life += me.g * 0.5;}
		if (me.r == splitE) {life += me.g * 0.5;}
		if (toN.r == goS) {life += toN.g; dir = goS; max = momentum;}
		if (toS.r == goN) {life += toS.g; dir = goN; max = momentum;}
		if (toW.r == goE) {life += toW.g; dir = goE; max = momentum;}
		if (toE.r == goW) {life += toE.g; dir = goW; max = momentum;}
		if (toN.r == splitS) {life += toN.g * 0.5;}
		if (toS.r == splitN) {life += toS.g * 0.5;}
		if (toW.r == splitE) {life += toW.g * 0.5;}
		if (toE.r == splitW) {life += toE.g * 0.5;}

		float original_b = me.b;
		me.b -= (drinkrate * ((life > 0.0) ? 1.0 : 0.0));
		if (me.b < 0.) {me.b = 0.;}
		float consumed = original_b - me.b;
		life += consumed * watertolife - starverate;

		// find best water source
		float hereb = me.b + instinct * sin(rnd1*time*3432.1);
		float Nb = toN.b + instinct * sin(rnd1*time*9624.5);
		float Sb = toS.b + instinct * sin(rnd1*time*2546.2);
		float Wb = toW.b + instinct * sin(rnd1*time*7535.7);
		float Eb = toE.b + instinct * sin(rnd1*time*3463.4);

		if (hereb > max) {max = hereb; dir = stay;}
		if (Nb + instinct * sin(rnd1*time*9624.5)> max) {max = Nb; dir = goN;}
		if (Sb + instinct * sin(rnd1*time*6737.5)> max) {max = Sb; dir = goS;}
		if (Eb + instinct * sin(rnd1*time*4774.5)> max) {max = Eb; dir = goE;}
		if (Wb + instinct * sin(rnd1*time*9746.5)> max) {max = Wb; dir = goW;}

		if ((life > splitthreshold) && (me.b > 0.2)) {
			if (dir == goN) {dir = splitN;}
			if (dir == goS) {dir = splitS;}
			if (dir == goW) {dir = splitW;}
			if (dir == goE) {dir = splitE;}
		}

		me.r = (life > 0.0) ? dir : stay;
		me.g = life;

		float floodx = waterrate * sin(mod(time, 12.34) * 7472.5);
		float floody = waterrate * sin(mod(time, 23.45) * 8462.9);
		if ((floodx > 0.15) && (floody > 0.15) && (floodx < 0.85) && (floody < 0.85)) {
			float dist = 1.5 - 30.0 * length(position-vec2(floodx,floody));
			if (dist > 0.0) {me.b += dist;}
		}
	}
	gl_FragColor = me;
}
