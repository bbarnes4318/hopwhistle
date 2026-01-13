import subprocess, time, json, random, os

# --- CONFIGURATION ---
AGENT_TRANSFER_NUMBER = "+18653969104"
TELNYX_VALID_DID = "+17868404940"
DID_FILE = '/opt/hopwhistle/dids.json'
LEAD_FILE = '/opt/hopwhistle/test_lead.txt'
PROGRESS_FILE = '/opt/hopwhistle/already_called.log'
PAUSE_FLAG = "/opt/hopwhistle/pause.flag"

# CARRIER CONFIGS
VOXBEAM_PREFIX = "0011104" # Call Center Route

def start_blast():
    print("--- NOVA-3 SMART FAILOVER DIALER STARTING ---")
    print("--- SEQUENCE: TELNYX -> VOXBEAM -> ANVEO ---")
    
    while True:
        if os.path.exists(PAUSE_FLAG):
            print("--- PAUSED ---")
            time.sleep(10)
            continue

        try:
            with open(DID_FILE, 'r') as f: DID_POOL = json.load(f)
            with open(LEAD_FILE, 'r') as f: leads = [l.strip() for l in f if l.strip()]
            done = []
            if os.path.exists(PROGRESS_FILE):
                with open(PROGRESS_FILE, 'r') as f: done = [l.strip() for l in f]
        except Exception as e:
            print(f"File Error: {e}")
            time.sleep(10)
            continue

        remaining = [l for l in leads if l not in done]

        if not remaining:
            print("--- CAMPAIGN COMPLETE ---")
            time.sleep(60)
            continue

        for customer_num in remaining:
            if os.path.exists(PAUSE_FLAG): break
            
            # 1. Prepare Number Formats
            clean = "".join(filter(str.isdigit, customer_num))
            
            # Telnyx Format (+1...)
            fmt_telnyx = f"+{clean}" if clean.startswith('1') else f"+1{clean}"
            
            # Voxbeam/Anveo Format (1...)
            fmt_clean = f"1{clean}" if not clean.startswith('1') else clean
            
            mask = random.choice(list(DID_POOL.keys())).replace('+', '')

            # 2. CONSTRUCT THE FAILOVER CHAIN (The Magic Part)
            # Syntax: carrier1|carrier2|carrier3
            # We use [] to set specific timeouts for each leg (e.g., give Telnyx 6 seconds before failing over)
            
            leg_a = f"[leg_timeout=6]sofia/internal/{fmt_telnyx}@sip.telnyx.com"
            leg_b = f"[leg_timeout=6]sofia/gateway/voxbeam/{VOXBEAM_PREFIX}{fmt_clean}"
            leg_c = f"[leg_timeout=6]sofia/gateway/anveo/{fmt_clean}"
            
            # The Pipe '|' creates the automatic fallback
            dial_string = f"{leg_a}|{leg_b}|{leg_c}"
            
            print(f"DIALING CHAIN: {customer_num}")
            
            # Global variables apply to ALL legs
            vars = (f"absolute_codec_string=PCMU,transfer_to_num={AGENT_TRANSFER_NUMBER},"
                    f"telnyx_auth_id={TELNYX_VALID_DID},fractel_mask_num={mask},"
                    f"origination_caller_id_number={TELNYX_VALID_DID},"
                    f"effective_caller_id_number={mask},effective_caller_id_name={mask},"
                    f"ignore_early_media=true,continue_on_fail=true") # continue_on_fail is key!

            cmd = f"docker exec docker-freeswitch-1 fs_cli -x \"bgapi originate {{{vars}}}{dial_string} &lua(/opt/hopwhistle/handler.lua)\""

            result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
            
            if result.returncode != 0:
                print(f"ERROR: {result.stderr}")
            else:
                print(f"SENT: {result.stdout.strip()}")

            with open(PROGRESS_FILE, 'a') as f: f.write(f"{customer_num}\n")
            time.sleep(random.uniform(10, 18))

if __name__ == '__main__':
    start_blast()
