package Utils;

import javax.sound.sampled.*;
import java.io.BufferedInputStream;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;

public class SoundController {
    private static SoundController instance;
    private Map<String, Clip> soundEffects;

    private SoundController() {
        soundEffects = new HashMap<>();
    }

    public static SoundController getInstance() {
        if (instance == null) {
            instance = new SoundController();
        }
        return instance;
    }

    public void loadSound(String name, String filepath) {
        try {
            InputStream is = SoundController.class.getClassLoader().getResourceAsStream(filepath);
            if (is == null) {
                throw new Exception("Audio file not found: " + filepath);
            }
            AudioInputStream audioStream = AudioSystem.getAudioInputStream(new BufferedInputStream(is));
            Clip clip = AudioSystem.getClip();
            clip.open(audioStream);
            soundEffects.put(name, clip);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void playSound(String name) {
        Clip clip = soundEffects.get(name);
        if (clip != null) {
            if (clip.isRunning()) {
                clip.stop();
            }
            clip.setFramePosition(0);
            clip.start();
        }
    }

    public void stopSound(String name) {
        Clip clip = soundEffects.get(name);
        if (clip != null && clip.isRunning()) {
            clip.stop();
        }
    }

    public void stopAll() {
        for (Clip clip : soundEffects.values()) {
            if (clip.isRunning()) {
                clip.stop();
            }
        }
    }
}
