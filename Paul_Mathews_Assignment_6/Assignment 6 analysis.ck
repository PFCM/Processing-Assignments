// Assignment 6 analyzer

// Signal chain
SndBuf s => FFT fft =^ RMS rms => blackhole;
s => dac;

UAnaBlob blob;
UAnaBlob blob2;// Blobs

// FFT variables
2048 => int FFT_SIZE;
FFT_SIZE => fft.size;
1024 => int WINDOW_SIZE;
WINDOW_SIZE/2 => int HOP_SIZE;
Windowing.hann(WINDOW_SIZE) => fft.window;

// SndBuf settings
"data/02 Happy Birthday.wav" => string file;
file => s.read;
1.2 => s.gain;// Quiet file

// OSC send settings and init
"localhost" => string HOST_NAME;
12001 => int OSC_PORT_OUT;
OscSend xmit;
xmit.setHost(HOST_NAME, OSC_PORT_OUT);

// Other variables
0 => int gate;
2.6 => float THRESHOLD;
int count;
int MaxI[4];

// RMS peak send function
fun void oscSend(float i)
{
    xmit.startMsg("/RMS_Peak","f");
     i => xmit.addFloat;
}

// pitch bin index send function
fun void pitchSend(int one, int two, int three, int four)
{
    xmit.startMsg("/pitches", "iiii");
    one => xmit.addInt;
    two => xmit.addInt;
    three => xmit.addInt;
    four => xmit.addInt;
} 

// Loop
while (true)
{
    // Array to get fft info
    float Z[FFT_SIZE/2];
    
    // Get things moving
    fft.upchuck() @=> blob2;
    rms.upchuck() @=> blob;
    rms.fval(0)*1000 => float rmsValue;// scale to something useful
    
    
    // Store fft data (not complex)
    for (0 => int i; i < Z.cap(); i++)
    {
        fft.fval(i) => Z[i];
    }
    
    // Find some peaks in the data
    MaxPeaks(Z, .005);
    
    // Send pitch data, but not all the time because that is probably not necessary
    if (count%15 == 0)
    {
        pitchSend(MaxI[0],MaxI[1],MaxI[2],MaxI[3]);
    }
    
    // If rms rises up over threshold
    if ((rmsValue > THRESHOLD) && (gate == 0))
    {
        1 => gate;// trip the gate
        oscSend(rmsValue-THRESHOLD);// send the amount we are over by
    } 
    // on the way back down
    else if ((rmsValue < THRESHOLD) && (gate == 1))
    {
        0 => gate;// reset the gate
    }
    
    // Advance by hop size to create overlap
    HOP_SIZE::samp => now;
    
    count++;//increment counter
    if (count > 300)//reset counter every now and then
    {
        0 => count;
    }
    
    // Loop song
    if (s.pos() > s.samples())
    {
        1::second => now;
        0 => s.pos;
    }
}

// Pitch detector
fun void MaxPeaks(float A[], float thresh)
{
    // Ready for a bit of filtering
    float LP[A.cap()-100];
    
    // Low pass by moving average to smooth peaks
    for (0 => int i; i < LP.cap()-1; i++)
    {
        (A[i]+A[i+1])/2 => LP[i];
    }
    0.0 => LP[LP.cap()-1];
    
    // peak counter
    0 => int t;
    
    /* Run through smoothed info to find peaks
     Running through backwards to get the lowest 4 peaks
     because going up gives us really high info, ideally
     we would fine the loudest of the peaks, but just finding
     the lowest is ok because it gets what we listen for and 
     is a lot less work */
     
    for (LP.cap()-1 => int i; i > 1; i--)
    {
        if (LP[i] > thresh)// Only consider it if it's above threshold
        {
            if ((LP[i] > LP[i-1]) && (LP[i] > LP[i+1]))// if peak
            {
                i => MaxI[t];// go in the array
                t++;// move the index for the next peak
                if (t >= MaxI.cap())
                {// wrap index 
                    0 => t;
                }
            }
        }
    }
}